#===============================================================================
#  Ruby MySQL Database schema record
#===============================================================================
module Database
  module Schema
    class Record
      #-------------------------------------------------------------------------
      #  return query result as a Ruby object
      #-------------------------------------------------------------------------
      def initialize(data, database, table)
        @schema_database_name = database
        @schema_table_name    = table

        data.each do |key, value|
          instance_variable_set("@#{key}", value)
          self.class.attr_reader(key)
        end

        build_relations
      rescue
        Env.error('Failed to create schema record object!')
      end
      #-------------------------------------------------------------------------
      #  update property of record
      #-------------------------------------------------------------------------
      def update(options = {})
        updates = []

        Array(options).each do |key, value|
          updates << "#{schema_table_name}.#{key} = '#{value}'"
        end

        sql = "UPDATE #{schema_table_name} SET " + updates.join(', ') + " WHERE #{schema_table_name}.id = '#{@id}'"

        Database::Connector.query(sql, schema_database_name.to_sym)
        reload
      end
      #-------------------------------------------------------------------------
      #  delete record from database
      #-------------------------------------------------------------------------
      def delete
        Database::Connector.query("DELETE FROM #{schema_table_name} WHERE #{schema_table_name}.id = '#{@id}'", schema_database_name.to_sym)

        nil
      end
      #-------------------------------------------------------------------------
      #  reload record content
      #-------------------------------------------------------------------------
      def reload
        schema_module.find_by(id: @id)
      end
      #-------------------------------------------------------------------------
      private
      #-------------------------------------------------------------------------
      attr_reader :schema_database_name, :schema_table_name
      #-------------------------------------------------------------------------
      #  get schema reference object
      #-------------------------------------------------------------------------
      def schema_module
        "Database::#{schema_database_name.camel_case}::#{schema_table_name.camel_case}".constantize
      end
      #-------------------------------------------------------------------------
      #  build schema relationships
      #-------------------------------------------------------------------------
      def build_relations
        #  build parent relationships
        schema_module.send(:parent_relations)&.each do |key, value|
          ref_column = value['reference_column'].underscore
          ref_table  = value['reference_table'].camel_case
          #  define new parent method
          self.class.define_method(ref_table.underscore) do
            child_module = "Database::#{schema_database_name.camel_case}::#{ref_table}".constantize

            child_module.find_by(ref_column => send(key.downcase.to_sym))
          end
        end
        #  build child relationships
        schema_module.send(:child_relations)&.each do |key, value|
          ref_column = value['reference_column'].underscore
          column     = value['column_name'].underscore
          #  define new child method
          self.class.define_method(key.underscore.pluralize) do
            child_module = "Database::#{schema_database_name.camel_case}::#{key.camel_case}".constantize

            child_module.where(column => send(ref_column.downcase.to_sym)).all
          end
        end
      rescue
        Env.error('Failed to build schema relationships!')
      end
      #-------------------------------------------------------------------------
    end
  end
end

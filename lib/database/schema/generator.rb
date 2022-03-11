#===============================================================================
#  Ruby MySQL Database framework
#===============================================================================
module Database
  module Schema
    #---------------------------------------------------------------------------
    #  generate Database::Table objects for simple use within the system
    #---------------------------------------------------------------------------
    module Generator
      class << self
        #-----------------------------------------------------------------------
        #  run object generator
        #-----------------------------------------------------------------------
        def run
          #  iterate through all connected databases
          Database::Connector.databases&.each do |db|
            #  query information schema
            sql = "SELECT table_name FROM information_schema.tables WHERE table_schema = '#{db}'"
            rel = "SELECT * FROM information_schema.key_column_usage WHERE constraint_schema = '#{db}' AND referenced_column_name IS NOT NULL"
            inf = "SELECT column_name, data_type FROM information_schema.columns WHERE table_schema = '#{db}'"

            # iterate through results
            Database::Connector.query(sql)&.each do |row|
              row = row.transform_keys(&:downcase)
              #  define metadata
              table     = row['table_name']
              model     = row['table_name'].camel_case
              database  = db.camel_case

              #  get parent schema relationships
              parent_relations = {}.tap do |hash|
                Database::Connector.query(rel + " AND table_name = '#{table}'")&.each do |row_rel|
                  row_rel = row_rel.transform_keys(&:downcase)
                  hash[row_rel['column_name']] = {
                    reference_table: row_rel['referenced_table_name'],
                    reference_column: row_rel['referenced_column_name']
                  }
                end
              end

              #  get child schema relationships
              child_relations = {}.tap do |hash|
                Database::Connector.query(rel + " AND referenced_table_name = '#{table}'")&.each do |row_rel|
                  row_rel = row_rel.transform_keys(&:downcase)
                  hash[row_rel['table_name']] = {
                    reference_column: row_rel['referenced_column_name'],
                    column_name: row_rel['column_name']
                  }
                end
              end

              #  get column data info
              data_types = {}.tap do |hash|
                Database::Connector.query(inf + " AND table_name = '#{table}'")&.each do |row_rel|
                  row_rel = row_rel.transform_keys(&:downcase)
                  hash[row_rel['column_name']] = row_rel['data_type']
                end
              end

              template = ERB.new(File.read("#{Dir.pwd}/lib/database/schema/template.erb")).result(binding)
              #  create new objects from results
              eval(template, TOPLEVEL_BINDING, __FILE__, __LINE__)
            end
          end
        end
        #-----------------------------------------------------------------------
      end
      #-------------------------------------------------------------------------
    end
  end
end

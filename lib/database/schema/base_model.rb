#===============================================================================
#  Ruby MySQL Database framework
#===============================================================================
module Database
  module Schema
    #---------------------------------------------------------------------------
    #  base record model object
    #---------------------------------------------------------------------------
    module BaseModel
      #-------------------------------------------------------------------------
      #  create new record in DB
      #-------------------------------------------------------------------------
      def create(options = {})
        columns = []
        values  = []

        options.each do |column, value|
          columns << column
          values  << "'#{value}'"
        end

        Database::Connector.query("INSERT INTO #{table_name}(#{columns.join(',')}) VALUES(#{values.join(',')})", db_name.to_sym)

        order(id: :desc).limit(1).first
      end
      #-------------------------------------------------------------------------
      #  SQL query relation object
      #-------------------------------------------------------------------------
      def query
        @query ||= Database::Schema::Query.new(table_name, db_name)
      end
      #-------------------------------------------------------------------------
      #  add keys for SELECT statement
      #-------------------------------------------------------------------------
      def select(options = {})
        query.select_sql(options)

        self
      end
      #-------------------------------------------------------------------------
      #  add clauses for WHERE statement
      #-------------------------------------------------------------------------
      def where(options = {})
        query.where_sql(options)

        self
      end
      #-------------------------------------------------------------------------
      #  add clauses for JOIN statement
      #-------------------------------------------------------------------------
      def joins(options = {})
        query.joins_sql(options)

        self
      end
      #-------------------------------------------------------------------------
      #  add clauses for GROUP BY statement
      #-------------------------------------------------------------------------
      def group(options = {})
        query.group_sql(options)

        self
      end
      #-------------------------------------------------------------------------
      #  add clauses for ORDER BY statement
      #-------------------------------------------------------------------------
      def order(options = {})
        query.order_sql(options)

        self
      end
      #-------------------------------------------------------------------------
      #  add clauses for OFFSET statement
      #-------------------------------------------------------------------------
      def offset(value)
        query.offset_sql(value)

        self
      end
      #-------------------------------------------------------------------------
      #  add clauses for LIMIT statement
      #-------------------------------------------------------------------------
      def limit(value)
        query.limit_sql(value)

        self
      end
      #-------------------------------------------------------------------------
      #  return all results as Ruby objects
      #-------------------------------------------------------------------------
      def all
        results(query.all)
      end
      #-------------------------------------------------------------------------
      #  return only first result
      #-------------------------------------------------------------------------
      def first
        results(query.first)
      end
      #-------------------------------------------------------------------------
      #  return only last result
      #-------------------------------------------------------------------------
      def last
        results(query.last)
      end
      #-------------------------------------------------------------------------
      #  return only mentioned keys from result
      #-------------------------------------------------------------------------
      def pluck(column)
        results(query.pluck(column))
      end
      #-------------------------------------------------------------------------
      #  find single specific result
      #-------------------------------------------------------------------------
      def find_by(options = {})
        where(options).first
      end
      #-------------------------------------------------------------------------
      #  return output and clear query content
      #-------------------------------------------------------------------------
      def results(rows)
        query.clear

        rows
      end
      #-------------------------------------------------------------------------
    end
  end
end

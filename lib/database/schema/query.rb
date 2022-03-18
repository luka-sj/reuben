#===============================================================================
#  Ruby MySQL Database framework
#===============================================================================
module Database
  module Schema
    #---------------------------------------------------------------------------
    #  query relation object to construct SQL
    #---------------------------------------------------------------------------
    class Query
      attr_reader :table_name, :db_name, :limit, :offset
      attr_accessor :select, :where, :order, :group, :joins
      #-------------------------------------------------------------------------
      #  constructor to initialize empty query content
      #-------------------------------------------------------------------------
      def initialize(table_name, db_name)
        @table_name = table_name
        @db_name    = db_name
        @select     = []
        @where      = []
        @order      = []
        @group      = []
        @joins      = []
        @limit      = 0
        @offset     = 0
      end
      #-------------------------------------------------------------------------
      #  add keys for SELECT statement
      #-------------------------------------------------------------------------
      def select_sql(rows = [])
        Array(rows).each do |row|
          select << "`#{table_name}`.`#{row}`"
        end
        select.compact!
        select.uniq!
      end
      #-------------------------------------------------------------------------
      #  add clauses for WHERE statement
      #-------------------------------------------------------------------------
      def where_sql(options = {}, table = table_name)
        Array(options).each do |key, value|
          if value.is_a?(Hash)
            #  get actual table name
            key = "Database::#{db_name.camel_case}::#{key.to_s.camel_case}".constantize.send(:table_name)
            where << where_sql(value, key)
          elsif value.is_a?(Array)
            where << "`#{table}`.`#{key}` IN (#{value.map { |row| "'#{row}'" }.join(', ')})"
          else
            where << "`#{table}`.`#{key}` = '#{value}'"
          end
        end
        where.compact!
        where.uniq!
      end
      #-------------------------------------------------------------------------
      #  add clauses for JOIN statement
      #-------------------------------------------------------------------------
      def joins_sql(rows = [])
        Array(rows).each do |value|
          joins << value
        end
        joins.compact!
        joins.uniq!
      end
      #-------------------------------------------------------------------------
      #  add clauses for GROUP BY statement
      #-------------------------------------------------------------------------
      def group_sql(options = {}, table = table_name)
        Array(options).each do |key, value|
          if value.is_a?(Array)
            value.each { |row| group << "`#{table}`.`#{row}`" }
          elsif value.is_a?(Hash)
            group << group_sql(value, key)
          else
            group << "`#{table}`.`#{key}`"
          end
        end
        group.compact!
        group.uniq!
      end
      #-------------------------------------------------------------------------
      #  add clauses for ORDER BY statement
      #-------------------------------------------------------------------------
      def order_sql(options = {}, table = table_name)
        Array(options).each do |key, value|
          if value.is_a?(Hash)
            order << order_sql(value, key)
          else
            order << "`#{table}`.`#{key}` #{value.upcase}"
          end
        end
        order.compact!
        order.uniq!
      end
      #-------------------------------------------------------------------------
      #  add clause for OFFSET
      #-------------------------------------------------------------------------
      def offset_sql(value)
        @offset = value
      end
      #-------------------------------------------------------------------------
      #  add clause for LIMIT
      #-------------------------------------------------------------------------
      def limit_sql(value)
        @limit = value
      end
      #-------------------------------------------------------------------------
      #  return all results as Ruby objects
      #-------------------------------------------------------------------------
      def all
        rows = []

        #  query from database
        Database::Connector.query(construct_sql, db_name.to_sym)&.each do |row|
          #  convert response row hash to Record object
          rows << Database::Schema::Record.new(row.transform_keys { |key| key.downcase.to_sym }, db_name, table_name)
        end

        rows
      end
      #-------------------------------------------------------------------------
      #  return only first result
      #-------------------------------------------------------------------------
      def first
        all[0]
      end
      #-------------------------------------------------------------------------
      #  return only last result
      #-------------------------------------------------------------------------
      def last
        all[-1]
      end
      #-------------------------------------------------------------------------
      #  return only mentioned keys from result
      #-------------------------------------------------------------------------
      def pluck(column)
        all.map { |row| row.send(column) }
      end
      #-------------------------------------------------------------------------
      #  clear all clauses
      #-------------------------------------------------------------------------
      def clear
        select.clear
        joins.clear
        where.clear
        group.clear
        order.clear
        @limit  = 0
        @offset = 0
      end
      #-------------------------------------------------------------------------
      private
      #-------------------------------------------------------------------------
      #  construct SQL query from registered clauses
      #-------------------------------------------------------------------------
      def construct_sql
        #  SELECT statement
        sql = ['SELECT']
        if select.is_a?(Array)
          sql << (select.empty? ? '*' : select.map { |str| "#{table_name}.#{str}" }.join(', '))
        elsif select.is_a?(String)
          sql << select
        else
          sql << '*'
        end
        #  FROM statement
        sql << "FROM #{table_name}"
        #  JOIN statements
        joins.each { |join| sql << join }
        #  WHERE statement
        if where.is_a?(Array)
          sql << (where.empty? ? '' : 'WHERE ' + where.select { |row| row.is_a?(String) }.join(' AND '))
        elsif where.is_a?(String)
          sql << "WHERE #{where}"
        end
        #  GROUP BY statement
        if group.is_a?(Array)
          sql << (group.empty? ? '' : 'GROUP BY ' + group.select { |row| row.is_a?(String) }.join(', '))
        elsif group.is_a?(String)
          sql << "GROUP BY #{group}"
        end
        #  ORDER BY statement
        if order.is_a?(Array)
          sql << (order.empty? ? '' : 'ORDER BY ' + order.select { |row| row.is_a?(String) }.join(', '))
        elsif order.is_a?(String)
          sql << "ORDER BY #{order}"
        end
        #  OFFSET statement
        sql << "OFFSET #{offset}" if offset.is_a?(Integer) && offset > 0
        #  LIMIT statement
        sql << "LIMIT #{limit}" if limit.is_a?(Integer) && limit > 0

        # return output
        sql.join(' ').strip
      rescue
        Env.error('Failed to construct SQL!')
      end
      #-------------------------------------------------------------------------
    end
  end
end

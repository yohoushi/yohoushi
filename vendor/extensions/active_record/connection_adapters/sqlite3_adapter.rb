# This monkey patch is an ugly workaround to avoid rake db:migrate error on rails4 with sqlite3. 
# Someone please tell me how to fix. cf. https://gist.github.com/sonots/5946319
begin
  gem 'sqlite3', '~> 1.3.6'
  require 'active_record/connection_adapters/sqlite3_adapter.rb'

  module ActiveRecord
    module ConnectionAdapters #:nodoc:
      class SQLite3Adapter < AbstractAdapter

        def exec_query_with_rescue(sql, name = nil, binds = [])
          begin
            exec_query_without_rescue(sql, name, binds)
          rescue ActiveRecord::StatementInvalid => e
            return if e.message.include?('SQLite3::SQLException') and e.message.include?('INSERT INTO "schema_migrations" ("version") VALUES (?)')
            raise e
          end
        end
        alias_method_chain :exec_query, :rescue

      end
    end
  end
rescue Gem::LoadError => e
  # Do not apply this monkey patch if 'sqlite3' gem is not loaded
end

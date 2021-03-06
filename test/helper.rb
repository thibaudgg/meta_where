require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'active_record'
require 'active_record/fixtures'
require 'active_support/time'

FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')

Time.zone = 'Eastern Time (US & Canada)'

ActiveRecord::Base.establish_connection(
  :adapter => defined?(JRUBY_VERSION) ? 'jdbcsqlite3' : 'sqlite3',
  :database => ':memory:'
)

dep = defined?(ActiveSupport::Dependencies) ? ActiveSupport::Dependencies : ::Dependencies
dep.autoload_paths.unshift FIXTURES_PATH

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load File.join(FIXTURES_PATH, 'schema.rb')
end

Fixtures.create_fixtures(FIXTURES_PATH, ActiveRecord::Base.connection.tables)

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'meta_where'
MetaWhere.operator_overload!

class Test::Unit::TestCase
end

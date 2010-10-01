SPEC_DIR = File.dirname(__FILE__)
lib_path = File.expand_path("#{SPEC_DIR}/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require "rubygems"
require "active_record"
require "active_record/fixtures"
require "acts_as_paranoid_versioned"
require "database_cleaner"

ActiveRecord::Schema.verbose = false

begin
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
rescue ArgumentError
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
end

ActiveRecord::Base.configurations = true

ActiveRecord::Schema.define(:version => 1) do
  create_table :workers do |t|
    t.string    :name
  end

  create_table :tasks do |t|
    t.references :worker
    t.datetime   :started_at
    t.datetime   :ended_at
    t.string     :name
    t.string     :state
  end
end

DatabaseCleaner.strategy = :truncation
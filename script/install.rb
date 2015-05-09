#!/usr/bin/env jruby

#
# run use java -classpath lib/gems.jar -jar lib/jruby-complete-1.7.17.jar install.rb
#
#ENV['GEM_HOME'] = File.expand_path("../jrubygems", __FILE__)
ENV['GEM_PATH'] = File.expand_path("../../jruby/1.9", __FILE__)

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require(:default, ENV['RACK_ENV'])



env = 'production'
databases = YAML.load_file File.expand_path('../../config/database.yml', __FILE__)
DB_CONFIG = databases[env]

puts "connecting to #{DB_CONFIG['database']}"


if ARGV.first == "force" then
	puts "creating db #{DB_CONFIG['database']}"
	ActiveRecord::Base.establish_connection DB_CONFIG.merge('database' => nil)
	ActiveRecord::Base.connection.drop_database DB_CONFIG['database']
	ActiveRecord::Base.establish_connection DB_CONFIG.merge('database' => nil)
	ActiveRecord::Base.connection.create_database DB_CONFIG['database'], charset: 'utf8'
end



ActiveRecord::Base.establish_connection DB_CONFIG

version =  nil
ActiveRecord::Migration.verbose = true
ActiveRecord::Migrator.migrate 'db/migrate', version

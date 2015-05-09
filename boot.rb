

# Set rack environment
ENV['RACK_ENV'] ||= "development"


#ENV['GEM_HOME'] = File.expand_path("../jrubygems", __FILE__)
ENV['GEM_PATH'] = File.expand_path("../jruby/1.9", __FILE__)

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require(:default, ENV['RACK_ENV'])



# Load runtime jar in lib path.
unless defined? RUN_EMBEDDED

	Dir["lib/*.jar"].each do |jar|
		next if jar.start_with? "lib/jruby"
		#next if ["lib/bundle-gems.jar","lib/gems.jar"].include?(jar)
		#puts "require #{jar}"
		jar_file = File.expand_path("../#{jar}", __FILE__)
		require jar_file
	end

end


# initialize log
require File.expand_path("../config/log4j_logger", __FILE__)
require File.expand_path("../config/cache", __FILE__)


# Dir.mkdir('log') unless File.exist?('log')
# Dir.mkdir('tmp') unless File.exist?('tmp')
# Dir.mkdir('cert_files') unless File.exist?('cert_files')


case ENV["RACK_ENV"]
when "production"
	java.lang.System.setProperty("logFilename",File.expand_path("../log/production.log", __FILE__))
	java.lang.System.setProperty("Log4jContextSelector","org.apache.logging.log4j.core.async.AsyncLoggerContextSelector")

	logger = ::Log4j::Logger.configure(:env=>"production")
	logger.level = ::Logger::INFO

when "development"
	logger = ::Log4j::Logger.configure(:env=>"development")
	logger.level = ::Logger::DEBUG
else
	logger = ::Logger.new("/dev/null")
end


ActiveRecord::Base.logger = logger
configuration = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(configuration[ENV["RACK_ENV"]])
ActiveSupport.on_load(:active_record) do
	self.include_root_in_json = false
	self.default_timezone = :local
	self.time_zone_aware_attributes = false
	self.logger = logger
	self.raise_in_transactional_callbacks = true
	# self.observers = :cacher, :garbage_collector, :forum_observer
end



#--------------  Load java classs  --------------------






require "./application"



#--------------  Load rack server  --------------------

# Set project configuration
#require File.expand_path("../app", __FILE__)
# require 'thick'
# options = {:port=>3300,:environment=>ENV["RACK_ENV"]}
# Thick.create(options)

if ARGV.any? and "c" == ARGV.last then
	require "irb"
	ARGV.clear
	if __FILE__.sub(/file:/, '') == $0.sub(/file:/, '')
		IRB.start(__FILE__)
	else
		# check -e option
		if /^-e$/ =~ $0
			IRB.start(__FILE__)
		else
			IRB.setup(__FILE__)
		end
	end
	
	#IRB.start(__FILE__)

else


	require 'torquebox-web'
	server = TorqueBox::Web.run(:port => 9292, :auto_start => false,:rackup =>File.expand_path('../config.ru', __FILE__),:root=>File.expand_path('../', __FILE__))
	
	if defined? RUN_EMBEDDED then
		server.start
	else
		server.run_from_cli
	end
	
end


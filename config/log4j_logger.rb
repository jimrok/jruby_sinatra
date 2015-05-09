require 'logger'
require 'java'

module Log4j
  class Logger < ::Logger

    java_import 'org.apache.logging.log4j.LogManager'

    LEVELS = {
      ::Logger::DEBUG => Java.org.apache.logging.log4j.Level::DEBUG,
      ::Logger::INFO => Java.org.apache.logging.log4j.Level::INFO,
      ::Logger::WARN => Java.org.apache.logging.log4j.Level::WARN,
      ::Logger::ERROR => Java.org.apache.logging.log4j.Level::ERROR,
    ::Logger::FATAL => Java.org.apache.logging.log4j.Level::FATAL }

    #
    # Configure Log4J.
    #
    def Logger.configure(options = {})

      if @logger.nil? then
        java.lang.System.setProperty("log4j.configurationFile",File.expand_path("../config/log4j2_#{options[:env]}.xml", __FILE__));
        @logger = new
      end

    end

    def Logger.logger
      @logger
    end

    def initialize
      @log4j = Java.org.apache.logging.log4j.LogManager.getLogger('ruby')
    end

    def add(severity, message = nil, progname = nil)
      content = (message or (block_given? and yield) or progname)
      @log4j.log(LEVELS[severity], content.to_java)
    end

    def puts(message)
      write(message.to_s)
    end

    def write(message)
      add(INFO, message)
    end

    def flush
      # No-op.
    end

    def close
      # No-op.
    end
  end
end

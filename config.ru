# Set application dependencies


# release thread current connection return to connection pool in multi-thread mode
use ActiveRecord::ConnectionAdapters::ConnectionManagement


require './application'
# Boot application
run JrubySiteApp

#run Sinatra::Application
require 'sinatra/base'
require 'sinatra/reloader' if development?
require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate/view_helpers/sinatra'
require "sinatra/cookies"

Sinatra::Application.run = false

#--------------  Load helpers  --------------------

#require "./app/helpers/certificate"


#--------------  Load models  --------------------

require "./app/models/concerns/model_cache"
require "./app/models/user"


#--------------  init code  --------------------





#--------------  Load web app  --------------------

require "./app/controllers/root"
require "./app/controllers/hello"

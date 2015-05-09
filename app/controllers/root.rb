class JrubySiteApp < Sinatra::Base
  enable :sessions
  set :session_secret, '329b309143561773b6b040ea128c001ca0dfa8aed17b3d4a42d7b3ae96531dd1b33faffe42ba2144eff02bde271c6f174b76815ae9c7989facc1da3686ab85cd'

  public_dir = File.dirname(__FILE__) + '/public'

  set :public_folder, public_dir
  set :static_cache_control, [:public, :max_age => 300]
  set :lock,false
  set :protection, :except => [:remote_token, :http_origin]
  #set :logging, true
  disable :logging
  set :views, File.expand_path('../../views', __FILE__)
  

  set :app_file,nil


  
  helpers do

    def logged_in?

      true

    end

  end


  before do

    pass = false
    pass = true if logged_in?



    unless pass

      halt 401, erb(:login,:layout=>false)
    end

  end

  after do

    host = env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-"
    method = env["REQUEST_METHOD"]
    path = env["PATH_INFO"]
    q = env["QUERY_STRING"].empty? ? "" : "?"+env["QUERY_STRING"]
    v = env["HTTP_VERSION"]
    status_code = status.to_s[0..3]
    _access = "#{host} #{method} #{path} #{q} #{v} #{status_code}"

    ::Log4j::Logger.logger.info(_access)
  end


end

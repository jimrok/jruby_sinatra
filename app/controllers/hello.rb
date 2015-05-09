# -*- coding: utf-8 -*-

class JrubySiteApp < Sinatra::Base



  #--------------------------- get --------------------------
  get ("/") do

    # @apps = App.all
    @time = Time.now

    erb :hello
  end

end

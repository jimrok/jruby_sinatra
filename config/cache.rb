require 'memcached'



class Rails

  def self.cache
  	@cache ||= Memcached::Rails.new(:servers => ['localhost:11211'])
    #@cache ||= ActiveSupport::Cache::MemoryStore.new  :compress=>true,:size=> 128.megabytes
  end

end

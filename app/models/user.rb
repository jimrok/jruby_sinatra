# -*- coding: utf-8 -*-

class User < ActiveRecord::Base
  include ModelCache

  model_cache do
    with_attribute :id
  end
end

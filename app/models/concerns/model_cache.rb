module ModelCache

  extend ActiveSupport::Concern

  included do
    after_commit :expire_cache, :on => :update
    after_touch :expire_cache
  end

  module ClassMethods

    def model_cache(&block)
      class_attribute :cached_associations
      instance_exec &block
    end


    def with_attribute(*attributes)
      self.cached_associations = attributes

      attributes.each do |attribute|

        class_eval <<-EOF
        def self.find_cached_by_#{attribute}(value)

          return nil if value.nil?

          Rails.cache.fetch attribute_cache_key("#{attribute}", value) do

            o_find = self.where(:"#{attribute}"=>value).first
            if (o_find) then
              o_find.after_cache_load
            end
            o_find
          end
        end

        EOF
      end

    end

    def read_multi(ids)
      _tabname = table_name
      _keys = ids.map {|x| "#{_tabname}/attribute/id/#{x}"}
      cached_insts = Rails.cache.read_multi *_keys

      insts = []
      lost_ids = []
      _ids = []

      ids.each do |_id|
        each_id = _id.to_i
        _key = "#{_tabname}/attribute/id/#{each_id}"
        find_obj = cached_insts[_key]
        if find_obj.nil? then
          lost_ids << each_id
          insts << nil
        else
          insts << find_obj
        end
        _ids << each_id
      end

      if lost_ids.any? then
        find_by_db = self.where(:id=>lost_ids).to_ary
        if find_by_db.any? then
          find_by_db.each do |r|
            Rails.cache.write "#{_tabname}/attribute/id/#{r.id}",r
            _id_index = _ids.index(r.id)
            if _id_index then
              insts[_id_index] = r
            else
              insts << r
            end
          end
        end
      end

      insts.compact!

      insts
    end

    def attribute_cache_key(_attr,_id)
      "#{table_name}/attribute/#{_attr}/#{_id}"
    end


    # def write_cache(o_inst)
    #   Rails.cache.write("#{table_name}/attribute/id/#{_id}",o_inst)
    # end

  end

  def cache_key
    "#{self.class.table_name}/attribute/id/#{self.id}"
  end

  def after_cache_load

  end

  def write_cache


    table_name = self.class.table_name
    self.class.cached_associations.each do |att|
      Rails.cache.write "#{table_name}/attribute/#{att}/#{self[att]}",self
    end

    true
  end

  def expire_attribute_cache
    expire_cache
  end

  def expire_cache
    table_name = self.class.table_name
    deleted = false
    self.class.cached_associations.each do |att|
      deleted = Rails.cache.delete "#{table_name}/attribute/#{att}/#{self[att]}"
    end
    deleted
  end



end

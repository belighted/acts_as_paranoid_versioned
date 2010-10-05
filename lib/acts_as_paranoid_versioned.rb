module ParanoidVersioned
  class BadOptions < StandardError
    def initialize( keys )
      super( "Keys: #{keys.join( "," )} are not known by ParanoidVersioned" )
    end
  end

  class MissingTriggers < StandardError
    def initialize
      super( "Key: triggered_by is mandatory in ParanoidVersioned" )
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_paranoid_versioned(options = {})
      include ParanoidVersioned::InstanceMethods

      bad_keys = options.keys - [:triggered_by]
      raise ParanoidVersioned::BadOptions.new( bad_keys ) unless bad_keys.empty?
      raise ParanoidVersioned::MissingTriggers.new unless options.keys.include?(:triggered_by)

      default_scope :conditions => {:ended_at => nil}

      cattr_accessor :triggering_fields
      self.triggering_fields = options.delete(:triggered_by)

      before_validation_on_create :set_start_date
      before_validation_on_update :create_new_paranoid_version, :if => :update_triggering_fields?
    end
  end

  module InstanceMethods
    def destroy
      self.ended_at = Time.now
      self.save!
    end

    def active?
      self.started_at.present? && self.ended_at.blank?
    end

    protected

    def set_start_date
      self[:started_at] ||= Time.now
    end

    def update_triggering_fields?
      self.triggering_fields.any?{|field| self.send("#{field.to_s}_changed?")}
    end

    def create_new_paranoid_version
      new_version = self.class.new(attributes.merge({:started_at => Time.now}))
      self.reload

      self.class.transaction do
        self.destroy
        new_version.save!
      end
    end
  end

  class ActiveRecord::Base
    include ParanoidVersioned
  end
end

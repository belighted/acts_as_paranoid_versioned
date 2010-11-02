module ParanoidVersioned
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_paranoid_versioned(options = {})
      include ParanoidVersioned::InstanceMethods

      default_scope :conditions => {:ended_at => nil} if options.delete(:paranoid) != false

      cattr_accessor :triggering_fields
      self.triggering_fields = options.delete(:triggered_by) || raise(ArgumentError, "triggered_by is mandatory")

      before_validation_on_create :init_start_date
      before_validation_on_update :create_new_paranoid_version, :if => :update_triggering_fields?
    end
  end

  module InstanceMethods
    def destroy
      self.ended_at = Time.now
      save!
    end

    def active?
      started_at.present? && ended_at.blank?
    end

    protected

    def init_start_date
      self.started_at ||= Time.now
    end

    def update_triggering_fields?
      (changes.keys & triggering_fields.map(&:to_s)).any?
    end

    def create_new_paranoid_version
      new_version = self.class.new(attributes.merge({:started_at => Time.now}))
      reload

      self.class.transaction do
        destroy
        new_version.save!
      end
    end
  end

  class ActiveRecord::Base
    include ParanoidVersioned
  end
end

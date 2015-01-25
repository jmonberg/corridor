class Abuse < ActiveRecord::Base
  belongs_to :abused,         :polymorphic => true
  belongs_to :reporting_user, :class_name => 'User'
  belongs_to :moderator,      :class_name => 'User'

  delegate :suspension_status, :suspended_at, :to => :abused

  ABUSE_STATUSES = ['Reported', 'Cleared', 'Suspended', 'Under Review']

  def suspension_status=(status)
    abused.suspension_status = status

    case status
      when 'Suspended', 'Under Review' then
        suspend!
      when 'Cleared'
        cleared!
        self.abuse_count = 0
      when 'Reported'
        cleared!
    end

    @save_abused = true
  end

  def cleared!
    abused.suspended_at = nil
    @save_abused = true
  end

  def suspend!
    abused.suspended_at = Time.now
    @save_abused = true
  end

  def after_save
    @save_abused && abused.save
  end

end

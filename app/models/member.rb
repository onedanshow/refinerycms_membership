class Member < User
  
  def self.per_page
    12
  end
  
  acts_as_indexed :fields => [:first_name, :last_name]
  
  validates :membership_level, :first_name, :last_name, :presence => true
  attr_accessible :membership_level, :first_name, :last_name, :title, :organization,
    :street_address, :city, :province, :postal_code, :phone, :fax, :website, 
    :enabled, :add_to_member_until, :role_ids

  set_inheritance_column :membership_level

  after_create :ensure_member_role
  after_create :deliver_confirmation_mail
  after_create :ensure_activation 
  
  def full_name
    "#{self.first_name} #{last_name}"
  end
  
  def email=(e)
    write_attribute(:email, e)
    write_attribute(:username, e)
  end
  
  def add_to_member_until
    @add_to_member_until || ''
  end
  
  def add_to_member_until=(n)
    @add_to_member_until = n
    add_year_to_member_until n.to_i if n && n.to_i > 0
  end
 
  def is_member?
    role_ids.include?(MEMBER_ROLE_ID)
  end

  def active_for_authentication?
    a = self.enabled && role_ids.include?(MEMBER_ROLE_ID)
    if RefinerySetting::find_or_set('memberships_timed_accounts', true)
      if member_until.nil?
        a = false
      else
        a = a && member_until.future?
      end
    end
    a
  end
  alias active? active_for_authentication?

  def lapsed?
    if RefinerySetting::find_or_set('memberships_timed_accounts', true)
      member_until.present? && member_until.past?

    else
      false
    end
  end

  def reject
    deactivate
    deliver_membership_mail('rejection_confirmation') 
  end

  def cancel
    deactivate 
    deliver_membership_mail('cancellation_confirmation')
  end

  def accept
    activate
    deliver_membership_mail('acceptance_confirmation')
  end

  def extend
    activate
    deliver_membership_mail('extension_confirmation')
  end

  def inactive_message
    self.is_new ? super : I18n.translate('devise.failure.locked')
  end 
  
  protected
  
  def nil_paid_until
    self.member_until = nil
  end
  
  def deactivate
    self.enabled = false
    self.is_new = false
    remove_member_role
    save!
  end  
  
  def activate
    self.is_new = false
    self.enabled = true
    nil_paid_until if lapsed? && RefinerySetting::find_or_set('memberships_timed_accounts', true)
    add_year_to_member_until if RefinerySetting::find_or_set('memberships_timed_accounts', true)
    ensure_member_role
    save!
  end
 
  def deliver_confirmation_mail
    deliver_membership_mail('application_confirmation')  
  end
  
  def deliver_membership_mail(name)
    if !!(RefinerySetting.send :get, "deliver_mail_#{name}_member")
      MembershipMailer.send("#{name}_member", self).deliver
    end
    
    if !!(RefinerySetting.send :get, "deliver_mail_#{name}_admin")
      @admins = User.where("email in (?)", RefinerySetting.get('deliver_notification_to_users'))
      @admins.each do |admin|
        MembershipMailer.send("#{name}_admin", self, admin).deliver
      end
    end 
  end

  def add_year_to_member_until(amount = 1)
    if amount && amount > 0
      self.member_until = member_until.nil? || lapsed? ? amount.year.from_now : member_until + amount.year
    end
  end
  
  def ensure_activation
    activate unless RefinerySetting.get('membership_approve_accounts')
  end


  def ensure_member_role
    self.roles << Role.find(MEMBER_ROLE_ID) unless role_ids.include?(MEMBER_ROLE_ID)
  end

  def remove_member_role
    self.roles.delete(Role.find(MEMBER_ROLE_ID))
  end

  def nil_paid_until
    self.member_until = nil
  end
end

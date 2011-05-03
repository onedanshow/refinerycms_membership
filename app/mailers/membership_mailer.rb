class MembershipMailer < ActionMailer::Base
  default :from => ADMIN_EMAIL
   
  def application_confirmation_member(member)
    @member = member
    assign_membership_email(__method__)
    mail(:to => member.email, :subject => @email.subject)
  end

  def application_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    assign_membership_email(__method__)
    mail(:to => @admin.email,
      :subject => @email.subject)
  end

  def acceptance_confirmation_member(member)
    @member = member
    assign_membership_email(__method__)
    mail(:to => member.email,
      :subject => @email.subject) 
  end

  def acceptance_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    assign_membership_email(__method__)
    mail(:to => @admin.email,
      :subject => @email.subject) 
  end

  def rejection_confirmation_member(member)
    @member = member
    assign_membership_email(__method__)
    mail(:to => member.email,
      :subject => @email.subject)
  end

  def rejection_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    assign_membership_email(__method__)
    mail(:to => @admin.email,
       :subject => @email.subject)
  end

  def extension_confirmation_member(member)
    @member = member
    assign_membership_email(__method__)
    mail(:to => member.email,
      :subject => @email.subject)
  end

  def extension_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    assign_membership_email(__method__)
    mail(:to => @admin.email,
      :subject => @email.subject) 
  end

  def cancellation_confirmation_member(member)
    @member = member
    assign_membership_email(__method__)
    mail(:to => member.email,
      :subject => @email.subject) 
  end

  def cancellation_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    assign_membership_email(__method__)
    mail(:to => @admin.email,
      :subject => @email.subject) 
  end
 
  protected
  
  def assign_membership_email(title)
    @email = MembershipEmail.where(:title => title).first
  end
  
end

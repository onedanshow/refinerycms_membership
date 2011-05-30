class MembershipMailer < ActionMailer::Base
  default :from => RefinerySetting.get('membership_from_email_address')
  
  layout 'mail_member'  
  
  def application_confirmation_member(member)
    @member = member
    setup_email_parts(__method__)
    mail(:to => member.email, :subject => @email.subject)
  end

  def application_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    setup_email_parts(__method__)
    mail(:to => @admin.email,
      :subject => @email.subject)
  end

  def acceptance_confirmation_member(member)
    @member = member
    setup_email_parts(__method__)
    mail(:to => member.email,
      :subject => @email.subject) 
  end

  def acceptance_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    setup_email_parts(__method__)
    mail(:to => @admin.email,
      :subject => @email.subject) 
  end

  def rejection_confirmation_member(member)
    @member = member
    setup_email_parts(__method__)
    mail(:to => member.email,
      :subject => @email.subject)
  end

  def rejection_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    setup_email_parts(__method__)
    mail(:to => @admin.email,
       :subject => @email.subject)
  end

  def extension_confirmation_member(member)
    @member = member
    setup_email_parts(__method__)
    mail(:to => member.email,
      :subject => @email.subject)
  end

  def extension_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    setup_email_parts(__method__)
    mail(:to => @admin.email,
      :subject => @email.subject) 
  end

  def cancellation_confirmation_member(member)
    @member = member
    setup_email_parts(__method__)
    mail(:to => member.email,
      :subject => @email.subject) 
  end

  def cancellation_confirmation_admin(member, admin)
    @member = member
    @admin = admin
    setup_email_parts(__method__)
    mail(:to => @admin.email,
      :subject => @email.subject) 
  end
 
  protected
  
  def setup_email_parts(title)
    @email = MembershipEmail.where(:title => title).first
    @header = MembershipEmailPart.where(:title => "email_header").first
    @footer = MembershipEmailPart.where(:title => "email_footer").first
  end
  
end

require "spec_helper"

describe MembershipMailer do
  
  before do
    # Load default templates
    load Rails.root.join('db', 'seeds', 'refinerycms_membership_emails.rb')
    load Rails.root.join('db', 'seeds', 'refinerycms_membership_email_parts.rb')

    @role = Role.make(:id => MEMBER_ROLE_ID, :title => "Member")
    @member = Member.make
    ActionMailer::Base.deliveries = []
    @admin = User.make
    @admin.add_role(:superuser)
  end

    
  it "should send application_confirmation_member" do
    membership_email = MembershipEmail.where(:title => 'application_confirmation_member').first
    email = MembershipMailer.application_confirmation_member(@member).deliver
    sent.length.should == 1    
    email.to.first.should == @member.email
    email.subject.should == membership_email.subject
  end
  
  it "should send application_confirmation_admin" do
    membership_email = MembershipEmail.where(:title => 'application_confirmation_admin').first
    email = MembershipMailer.application_confirmation_admin(@member, @admin).deliver
    sent.length.should == 1    
    email.to.first.should == @admin.email
    email.subject.should == membership_email.subject
  end 
  
  it "should send acceptance_confirmation_member" do
    membership_email = MembershipEmail.where(:title => 'acceptance_confirmation_member').first
    email = MembershipMailer.acceptance_confirmation_member(@member).deliver
    sent.length.should == 1    
    email.to.first.should == @member.email
    email.subject.should == membership_email.subject
  end 
  
  it "should send acceptance_confirmation_admin" do
    membership_email = MembershipEmail.where(:title => 'acceptance_confirmation_admin').first
    email = MembershipMailer.acceptance_confirmation_admin(@member, @admin).deliver
    sent.length.should == 1    
    email.to.first.should == @admin.email
    email.subject.should == membership_email.subject
  end
  
  it "should send rejection_confirmation_member" do
    membership_email = MembershipEmail.where(:title => 'rejection_confirmation_member').first
    email = MembershipMailer.rejection_confirmation_member(@member).deliver
    sent.length.should == 1    
    email.to.first.should == @member.email
    email.subject.should == membership_email.subject
  end
  
  it "should send rejection_confirmation_admin" do
    membership_email = MembershipEmail.where(:title => 'rejection_confirmation_admin').first
    email = MembershipMailer.rejection_confirmation_admin(@member, @admin).deliver
    sent.length.should == 1    
    email.to.first.should == @admin.email
    email.subject.should == membership_email.subject
  end
  
  it "should send extension_confirmation_member" do
    membership_email = MembershipEmail.where(:title => 'extension_confirmation_member').first
    email = MembershipMailer.extension_confirmation_member(@member).deliver
    sent.length.should == 1    
    email.to.first.should == @member.email
    email.subject.should == membership_email.subject
  end
  
  it "should send extension_confirmation_admin" do
    membership_email = MembershipEmail.where(:title => 'extension_confirmation_admin').first
    email = MembershipMailer.extension_confirmation_admin(@member, @admin).deliver
    sent.length.should == 1    
    email.to.first.should == @admin.email
    email.subject.should == membership_email.subject
  end
 
  it "should send cancellation_confirmation_member" do
    membership_email = MembershipEmail.where(:title => 'cancellation_confirmation_member').first
    email = MembershipMailer.cancellation_confirmation_member(@member).deliver
    sent.length.should == 1    
    email.to.first.should == @member.email
    email.subject.should == membership_email.subject
  end

  it "should send cancellation_confirmation_admin" do
    membership_email = MembershipEmail.where(:title => 'cancellation_confirmation_admin').first
    email = MembershipMailer.cancellation_confirmation_admin(@member, @admin).deliver
    sent.length.should == 1    
    email.to.first.should == @admin.email
    email.subject.should == membership_email.subject
  end

  protected

  def sent
    ActionMailer::Base.deliveries 
  end
end

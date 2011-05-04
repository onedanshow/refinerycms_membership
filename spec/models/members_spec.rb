require 'spec_helper'

describe Member do
  
  before do
    if (seed_file = Rails.root.join('db', 'seeds', 'refinerycms_membership_emails.rb')).file?
      load seed_file.to_s 
    end
 
    Role.make(:title => "Member", :id => MEMBER_ROLE_ID) 
      
    @admin = User.make
    @admin.add_role(:superuser)
    RefinerySetting.set("deliver_notification_to_users", [@admin.email])
    
    @member = Member.make
    # clear mail so we can make correct assertions
    ActionMailer::Base.deliveries = []
  end

  context "when creating a member" do
    it "should deliver notifications after create" do
      deliver_on_create_member(true)
      @member = Member.make
      sent.length.should == 2
      sent.collect(&:to).flatten.should include @member.email
      sent.collect(&:to).flatten.should include @admin.email
    end
    
    it "should not deliver notification after create if setting is false" do
      deliver_on_create_member(false)
      Member.make
      sent.length.should == 0
    end 

    it "should be active_for_authentication if membership_approve_accounts is false" do
      RefinerySetting.set('membership_approve_accounts', false)
      deliver_on_create_member  
      @member.active_for_authentication?.should == true  
    end  
      
  end


  context "When extending membership" do
  
    it "should deliver mail" do
      RefinerySetting.set('deliver_mail_extension_confirmation_member', true)
      RefinerySetting.set('deliver_mail_extension_confirmation_admin', true)
      @member.extend
      sent.length.should == 2
      sent.collect(&:to).flatten.should include @member.email
      sent.collect(&:to).flatten.should include @admin.email
    end
    
    it "should not deliver mail if setting is false" do
      RefinerySetting.set('deliver_mail_extension_confirmation_member', false)
      RefinerySetting.set('deliver_mail_extension_confirmation_admin', false)
      @member.extend
      sent.length.should == 0 
    end 
  end

  context "When cancelling membership" do
    it "should deliver mail" do
      RefinerySetting.set('deliver_mail_cancellation_confirmation_member', true)
      RefinerySetting.set('deliver_mail_cancellation_confirmation_admin', true)
      @member.cancel
      sent.length.should == 2
      sent.collect(&:to).flatten.should include @member.email
      sent.collect(&:to).flatten.should include @admin.email
    end
  
    it "should not deliver mail if setting is false" do
      RefinerySetting.set('deliver_mail_cancellation_confirmation_member', false)
      RefinerySetting.set('deliver_mail_cancellation_confirmation_admin', false)
      @member.extend
      sent.length.should == 0 
    end 

  end

  context "When accepting membership" do
    it "should deliver mail" do
      RefinerySetting.set('deliver_mail_acceptance_confirmation_member', true)
      RefinerySetting.set('deliver_mail_acceptance_confirmation_admin', true)
      @member.accept
      sent.length.should == 2
      sent.collect(&:to).flatten.should include @member.email
      sent.collect(&:to).flatten.should include @admin.email
    end
  
    it "should not deliver mail if setting is false" do
      RefinerySetting.set('deliver_mail_acceptance_confirmation_member', false)
      RefinerySetting.set('deliver_mail_acceptance_confirmation_admin', false)
      @member.accept
      sent.length.should == 0 
    end 


  end
  
  context "When rejecting membership" do

    it "should deliver mail" do
      RefinerySetting.set('deliver_mail_rejection_confirmation_member', true)
      RefinerySetting.set('deliver_mail_rejection_confirmation_admin', true)
      @member.reject
      sent.length.should == 2
      sent.collect(&:to).flatten.should include @member.email
      sent.collect(&:to).flatten.should include @admin.email
    end
  
    it "should not deliver mail if setting is false" do
      RefinerySetting.set('deliver_mail_rejection_confirmation_member', false)
      RefinerySetting.set('deliver_mail_rejection_confirmation_admin', false)
      @member.reject
      sent.length.should == 0 
    end 

  end
  
  context "When inspecting lapsed? attr" do 
    it "should not be lapsed with blank member until" do
      @member.member_until = nil
      @member.lapsed?.should == false
    end
    
    it "should be lapsed if member_until in the past" do
      @member.member_until = 2.days.ago
      @member.lapsed?.should == true
    end

    it "should not be lapsed if member_until in the true" do
      @member.member_until = 2.days.from_now
      @member.lapsed?.should == false
    end
    
    it "should not be lapsed if timed setting is falsed" do
      RefinerySetting.set('membership_timed_accounts', false)
      @member.lapsed?.should == false 
    end
  end
 
  protected
  
  def sent
    ActionMailer::Base.deliveries 
  end
  
  def deliver_on_create_member(deliver=true)
    RefinerySetting.set('deliver_mail_application_confirmation_member', deliver) 
    RefinerySetting.set('deliver_mail_application_confirmation_admin', deliver)
  end
end

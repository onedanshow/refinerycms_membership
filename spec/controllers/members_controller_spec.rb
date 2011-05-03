require 'spec_helper'

describe MembersController do
  include Devise::TestHelpers
  
  before(:each) do
    load Rails.root.join('db', 'seeds', 'refinerycms_membership_emails.rb')
  
    ActionMailer::Base.deliveries = []
    controller.stub(:show_welcome_page?).and_return(false)

    @role = Role.make(:id => MEMBER_ROLE_ID, :title => "Member")
    @member = Member.make
    
    @user = User.make
    @user.add_role(:superuser)
  
    RefinerySetting.set("deliver_notification_to_users", [@user.email]) 
  end
  
  context "When creating a new member" do
    
    it 'should render sign up page' do
      get :new
  
      response.should be_success
      response.should render_template('members/new')
    end
      
    it 'should create new member and deliver confirmation mail' do
      post :create, :member => {"email"=>"test@test2.com", 
                                            "password"=>"testpw", "password_confirmation"=>"testpw", 
                                            "first_name"=>"Test", "last_name"=>"User", "title"=>"mr"}
      response.should be_redirect
      sent.first.to.first.should  == "test@test2.com"
      sent.last.to.first.should == @user.email 
    end
  
    it "should render new page with invalid attributes" do
      post :create, :member => {:username => ""}
  
      response.should be_success
      response.should render_template("members/new")
    end
  
  end
  
  context "When updating a member" do
    
    it "should render edit page" do
      sign_in @member
      get :edit
    
      response.should be_success
      response.should render_template('members/edit')
    end
  
    it "should update current_member" do
      sign_in @member
      put :update, :member => {"first_name" => "Harry Potter"}
      
      response.should be_redirect   
      assigns(:current_user).first_name.should == "Harry Potter"
    end
    
    it "should render edit page with invalid attributes" do
      sign_in @member
      put :update, :member => {:username => "", :email => ""}
      
      response.should be_success
      response.should render_template("members/edit")
    end
    
  end
  
  context "When trying to access user dashboard" do
    
    it 'should render page when signed in' do
      sign_in @member
      get :dashboard
      
      response.should render_template('members/dashboard')
      response.should be_success
    end
  
  
    it 'should redirect if not signed in' do
      get :dashboard
      response.should be_redirect
    end
    
  end
  
  context "" do
    
  end
  
  protected
  
  def sent
    ActionMailer::Base.deliveries
  end
end


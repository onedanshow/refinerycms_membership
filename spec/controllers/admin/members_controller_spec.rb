require 'spec_helper'

module Admin
  describe MembersController do
    include Devise::TestHelpers

    before do
      @user = User.make
      @user.add_role(:superuser)
      Role.make(:id => MEMBER_ROLE_ID, :title => "Member") 
      @member = Member.make
      sign_in @user
    end

    it "should put extend" do
      put :extend_member, :id => @member.id

      response.should be_success
    end 

    it "should put cancel" do
      put :cancel, :id => @member.id
    
      response.should be_success
    end 

    it "should put enable" do
      put :enable, :id => @member.id
    
      response.should be_success
    end

    it "should put accept" do
      put :accept, :id => @member.id
    
      response.should be_success
    end

    it "should put reject" do
      put :reject, :id => @member.id

      response.should be_success
    end
  end
end

class MembersController < ApplicationController

  # Protect these actions behind member login - do we need to check out not signing up when signed in?
  before_filter :authenticate_user!, :except => [:new, :create, :login, :index, :thank_you]

  before_filter :find_page

  # GET /member/:id
  def profile
    @member = current_user
  end

  def new
    @member = Member.new
  end

  # GET /members/:id/edit
  def edit
    @member = current_user
  end

  # PUT /members/:id
  def update
    @member = current_user

    if params[:member][:password].blank? and params[:member][:password_confirmation].blank?
      params[:member].delete(:password)
      params[:member].delete(:password_confirmation)
    end


    if @member.update_attributes(params[:member])
      flash[:notice] = t('successful', :scope => 'members.update', :email => @member.email)
      redirect_to profile_members_path
    else
      render :action => 'edit'
    end
  end

  def create
    @member = Member.new(params[:member])

    if @member.save
      MembershipMailer.application_confirmation_member(@member).deliver
      @admins = User.where("email in (?)", RefinerySetting.get("deliver_notification_to_users")).all
      @admins.each do |admin|
        MembershipMailer.application_confirmation_admin(@member, admin).deliver 
      end
      redirect_to thank_you_members_path
    else
      @member.errors.delete(:username) # this is set to email
      render :action => :new 
    end

  end

  def searching?
    params[:search].present?
  end

	def login
	end
	
  def thank_you
  end
  
  def dashboard
  end

  private

protected

  def find_page
    uri = request.fullpath
    uri.gsub!(/\?.*/, '')
    # devise login failure...
    uri = '/members/login' if uri == '/registrations/login'
    @page = Page.find_by_link_url(uri, :include => [:parts, :slugs])
  end
end

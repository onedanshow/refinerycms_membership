module Admin
  class MembershipEmailsController < Admin::BaseController
    crudify :membership_email, 
      :title_attribute => :title,
      :order => "title ASC"
  
    def index
      find_all_membership_emails
      filter_membership_emails 
      @membership_email_parts = MembershipEmailPart.all   
    end
  
    def settings
      find_all_membership_emails
      filter_membership_emails
      @users = User.where(['membership_level <> ? OR membership_level IS NULL', 'Member']).all
    end
    
    def save_settings
      params[:settings].each do | key, value |
        value.reject!{|v| !v || v == ''} if value.is_a?(Array)
        puts "#{key} #{value}"        
        RefinerySetting.set(key, value)
      end if params[:settings].present?
      render :text => "<script>parent.window.$('.ui-dialog .ui-dialog-titlebar-close').trigger('click');</script>"
    end
 
    protected

    def filter_membership_emails
      @membership_emails = @membership_emails.reject {|e|e.title =~ /(accept|reject)/} if !RefinerySetting.find_or_set('membership_approve_accounts', false)  
      @membership_emails = @membership_emails.reject {|e|e.title =~ /(extension)/} if !RefinerySetting.find_or_set('membership_timed_accounts', false)
    end
  end
end

# from: http://railscasts.com/episodes/237-dynamic-attr-accessible
# originally has same problem as: https://github.com/plataformatec/devise/issues/206#issuecomment-188325
module MembershipAdditions
  
  private 
  
  def mass_assignment_authorizer
    super + [:role_ids]
  end
  
end

Page.send(:include,MembershipAdditions)
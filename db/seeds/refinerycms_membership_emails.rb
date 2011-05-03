MembershipEmail.destroy_all

MembershipEmail.new({
  :title => 'application_confirmation_member',
  :subject => 'Welcome',
  :text => '<p>Welcome email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'application_confirmation_admin',
  :subject => 'Welcome',
  :text => '<p>Welcome email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'acceptance_confirmation_member',
  :subject => 'Accepted',
  :text => '<p>Accepted email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'acceptance_confirmation_admin',
  :subject => 'Accepted',
  :text => '<p>Accepted email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'rejection_confirmation_member',
  :subject => 'Rejection',
  :text => '<p>Rejection email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'rejection_confirmation_admin',
  :subject => 'Rejection',
  :text => '<p>Rejection email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'extension_confirmation_member',
  :subject => 'Extended',
  :text => '<p>Extended email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'extension_confirmation_admin',
  :subject => 'Extended',
  :text => '<p>Extended email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'cancellation_confirmation_member',
  :subject => 'Cancellation',
  :text => '<p>Cancellation email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'cancellation_confirmation_admin',
  :subject => 'Rejection',
  :text => '<p>Rejection email</p>'
}).save(:validate => false)

MembershipEmail.new({
  :title => 'profile_update_notification_admin',
  :subject => 'Update notification',
  :text => '<p>Profile Update Notification</p>'
}).save(:validate => false)


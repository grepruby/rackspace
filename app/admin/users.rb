ActiveAdmin.register User do
  index do
    column "Email" do |u|
      u.email unless u.email.blank?
    end
    column :first_name do |u|
      u.first_name unless u.first_name.blank?
    end
    column :last_name do |u|
      u.last_name unless u.last_name.blank?
    end
    column "Signed Up Date", :created_at
    column "Confirm", :confirm
      column do |user|
      span link_to "View", admin_user_path(user)
      span link_to "Edit", edit_admin_user_path(user)
      span link_to "Delete", admin_user_path(user), :method => "delete"
      span link_to "Activate account", "/admin/users/" + user.id.to_s + "/activate_user_account", :confirm => 'are you sure to activate this account?' if user.confirm == false
      span link_to "Deactivate account", "/admin/users/" + user.id.to_s + "/deactivate_user_account", :confirm => 'are you sure to deactivate this account?' if user.confirm == true
    end
  end
  
  member_action :activate_user_account do
    @user = User.find(params[:id])
    @user.confirm = true
    if @user.save(:validate => false)
      redirect_to admin_users_path, :flash => {:notice => "Account successfully activated"}
    end
  end
  
  member_action :deactivate_user_account do
    @user = User.find(params[:id])
    @user.confirm = false
    if @user.save(:validate => false)
      redirect_to admin_users_path, :flash => {:notice => "Account successfully deactivated"}
    end
  end
end

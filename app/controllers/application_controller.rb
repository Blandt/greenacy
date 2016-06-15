class ApplicationController < ActionController::Base
  before_filter :check_order

  protect_from_forgery
  layout :layout_by_resource
  protected

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      "admin_logsign"
    else
      "application"
    end
  end

  def check_if_logged_in
    deny_access unless signed_in?
  end

  def check_order
    if(current_user)
      @isOrder = Order.where(is_active: '1',is_closed: '0',user_id:current_user.id).first
      #if(!@isOrder)
      #  if(current_user.role_id==4)
      #    @userOfManagers = User.where(parent_id:current_user.id)
      #    @userOfManagers.each do |userOfManager|
      #      @isOrder = Order.where(is_active: '1',is_closed: '0',user_id:userOfManager.id).first
      #    end
      #  end
      #end
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_name != :admin
       record_activity("Loged in")
       return
    #else
        #record_activity("Loged in")
        return
    end
    #record_activity("Loged in")
    #return
  end

  #def before_sign_out_path_for(resource_or_scope)
  #  record_activity("Logout")
  #  return
  #end

  def record_activity(note)
    @activity = ActivityLog.new
    @activity.user_id = current_user.id
    @activity.note = note
    @activity.browser = request.env['HTTP_USER_AGENT']
    @activity.ip_address = request.env['REMOTE_ADDR']
    @activity.controller = controller_name
    @activity.action = action_name
    @activity.params = params.inspect
    @activity.parent_user_id = current_user.parent_id
    @activity.save
  end
end

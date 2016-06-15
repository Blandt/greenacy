class UserSessionsController < Devise::SessionsController
 after_filter :after_login

 def after_login
    if resource_name != :admin
       #record_activity("Loged in")
    #else
        #record_activity("Loged in")
    end
 end
end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def check_link_auth(link_controller, link_action)
    user = User.find_by_id(session[:user_id])
    unless user.roles.detect{|role|
      role.rights.detect{|right|
        (right.action == link_action || right.action == '*' ) && ( right.controller == link_controller || right.controller == '*')
        }
      }
      return false
    end
    return true
  end  
end

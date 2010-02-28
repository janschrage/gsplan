# GSPlan - Team commitment planning
#
# Copyright (C) 2008 Jan Schrage <jan@jschrage.de>
# 
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU 
# General Public License as published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with this program. 
# If not, see <http://www.gnu.org/licenses/>.


# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "GSPlan"
  before_filter :authenticate_user, :check_authorization, :except => :login  

  helper :all # include all helpers, all the time

  
  # Specify ZiYa Helpers  
  helper Ziya::HtmlHelpers::Charts
  helper Ziya::YamlHelpers::Charts
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'ae52f0f00c85ec07d939df56fa21e938'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password
  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at, :lock_version]
  end

  
protected
  def authenticate_user
    unless User.find_by_id(session[:user_id]) or User.count.zero?
      session[:original_uri] = request.request_uri
      redirect_to :controller => :admin, :action => :login
    end
    return false
  end

  def check_authorization
    unless User.count.zero?
      user = User.find_by_id(session[:user_id])
      unless user.roles.detect{|role|
        role.rights.detect{|right|
          (right.action == action_name || right.action == '*' ) && ( right.controller == self.class.controller_path || right.controller == '*')
          }
        }
        flash[:error] = "You are not authorized to view the page you requested"
        request.env["HTTP_REFERER" ] ? (redirect_to :back) : (redirect_to "/")
        return false
      end
    end
  end
  
end

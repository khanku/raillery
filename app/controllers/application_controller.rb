# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  # get a setting
  def get_setting(key)
   @setting = Setting.find(:first, :conditions => ["key = ?", key], :limit => 1 )
   return @setting.value
  end
end

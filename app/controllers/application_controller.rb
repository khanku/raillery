# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem
  include ApplicationEnvironment  # shared functions

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password


  private
    # this will grab the errors, like error_messages_for, but for controllers
    def get_errors_for(object) #format errors
      @string = ''

      if object.errors
        object.errors.each do |error, message|
          @string << "« #{error} » #{message}<br />"
        end
      end

      return @string
    end

end

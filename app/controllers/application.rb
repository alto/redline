# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all

  include AuthenticatedSystem

  before_filter :check_for_inviter

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'fb82bc52ca4d74e4ed2937ebd640a59c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  protected
    def check_for_inviter
      unless params["inviter"].blank?
        session[:inviter] = params.delete("inviter")
        redirect_to params
      end
      true
    end

    def implant_inviter_url(url, inviter)
      return url unless inviter
      if url =~ /\?/
        url.gsub!('?', "?inviter=#{inviter.login}&")
      elsif url =~ /#/
        url.gsub!('#', "?inviter=#{inviter.login}#")
      else
        url += "?inviter=#{inviter.login}"
      end
      url
    end
  
end

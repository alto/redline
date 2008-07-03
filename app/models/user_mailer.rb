class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject     += 'Please activate your new account'
  end
  
  def activation(user)
    setup_email(user)
    @subject     += 'Your account has been activated!'
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "noreply@42towels.com"
      @subject     = "[todoo.de] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end

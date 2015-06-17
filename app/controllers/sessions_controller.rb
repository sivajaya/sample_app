class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
     if user && user.password_digest && user.authenticate(params[:session][:password])
        if user.activated?
         log_in user
        else
         flasg[:warning]="Check your email for activation"
        end
        remember user
        redirect_to user
      else
        flash[:danger] =' Invalid email/password combination'
        render 'new'
      end
  end
  def destroy
     log_out 
     redirect_to root_path
  end
end

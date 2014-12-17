class SessionsController < ApplicationController
  def new

  end
  def create
      user = User.find_by(email: params[:session][:email].downcase)
      if user && User.find_by(name: params[:session][:name])
        sign_in user
        redirect_back_or(user)
      else
        flash.now[:error] = "Invalid name/email information"
        render 'new'
      end
  end
  def destroy

    sign_out
    redirect_to root_path
  end
end

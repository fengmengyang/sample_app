class SessionsController < ApplicationController
  def new

  end
  def create
      user = User.find_by(email: params[:session][:email].downcase)
      if user && User.find_by(name: params[:session][:name])
        sign_in user
        redirect_to user
      else
        flash.now[:error] = "Invalid name/email information"
        render 'new'
      end
  end
  def destroy

  end
end

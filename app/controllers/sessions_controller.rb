class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by(email_id: params[:login])
        puts params
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            puts "logged in"
            redirect_to home_path
        else
            puts "not logged in"
            flash.now.alert = "Username or password is invalid"
            render action: "new"
        end

    end

    def destroy
        session[:user_id] = nil
        redirect_to home_path, notice: "You have been logged out."
    end
end

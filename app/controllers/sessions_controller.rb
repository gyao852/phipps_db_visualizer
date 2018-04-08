class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.authenticate(params[:login],params[:passwords])
        if user
            session[:user_id] = user.user_id
            redirect home_path, notice: "Logged in successfully."
        else
            flash.now[:alert] = "Invalid login or password."
            render acion: 'new'
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to home_path, notice: "You have been logged out."
    end
end
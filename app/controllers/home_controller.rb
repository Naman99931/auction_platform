class HomeController < ApplicationController
    before_action :authenticate_user!, only: [:user_profile]
    def index
    end

    def user_profile
        @user = current_user
    end
end

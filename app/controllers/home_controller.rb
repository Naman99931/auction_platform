class HomeController < ApplicationController
    before_action :authenticate_user!, only: [:user_profile, :approve_request]
    before_action :check_admin, only: [:all_sellers, :all_bidders, :show_notifications, :approve_user]
    before_action :add_details_params, only: [:add_details]
    def index
    end

    def user_profile
        @user = current_user
    end

    def all_sellers 
        authorize! :all_sellers, :sellers
        if check_admin
          @sellers = User.where(role:"seller").where(approved: true)
        else
          respond_to do |format|
            format.html { redirect_to items_url, notice: "Your Account is not approved yet" }
          end
        end
    end
    
    def all_bidders
        authorize! :all_bidders, :bidders
        if check_admin
            @bidders = User.where(role:"bidder").where(approved: true)
        else
            respond_to do |format|
              format.html { redirect_to items_url, notice: "Your Account is not approved yet" }
            end
        end
    end

    def approve_request
        if params[:role].present?
            role = params[:role]
            current_user.update_column(:role, role)
        end
        @user = current_user
    end

    def add_details
        @user = current_user
        current_user.update(add_details_params)
        if current_user.save
            UserRegisterNotifyJob.perform_later(@user)
            redirect_to root_path, notice: "Request Sent Successfully."
        else
            render approve_request
        end
    end

    def show_notifications
        if current_user_role == "admin"
            if check_admin
                @notifications = Notification.all
            else
                respond_to do |format|
                format.html { redirect_to items_url, notice: "Your Account is not approved yet" }
                end
            end
        else
            @notifications = Notification.all
        end
    end

    def approve_user
        notification = Notification.find(params[:id])
        if can? :approve_seller, notification
            user = User.find(params[:user_id])
            user.update_column(:approved, true)
            notification.destroy
            UserMailer.account_approved(user).deliver_later
            respond_to do |format|
            format.html { redirect_back fallback_location: home_show_notifications_path, notice: "User approved" }
            end
        else
            head :forbidden
        end
    end

    def approve_item
        notification = Notification.find(params[:id])
        # add authentication
        item = Item.find(params[:item_id])
        item.update_column(:approved, true)
        user = User.find(item.user_id)
        UserMailer.item_got_approved(user).deliver_later
        notification.destroy
        respond_to do |format|
            format.html { redirect_back fallback_location: home_show_notifications_path, notice: "Item approved" }
        end
    end

    def view_profile
        @user = User.find_by(id:params[:id])
    end

    def flag_item
        item = Item.find(params[:item_id])
        notification = Notification.find(params[:id])
        seller = User.find(item.user_id)
        item.update_column(:flagged, true)
        notification.destroy
        seller.notifications.create(note:"Your Item got flagged.", item_id:item.id, user_role:"seller")
        respond_to do |format|
            format.html { redirect_back fallback_location: home_show_notifications_path, notice: "Item Flagged" }
        end
    end

    def report_user
        user = User.find(params[:id])
        user.notifications.create(note:"#{user.firstname} is reported by #{current_user.firstname}", user_role:"admin")
        user.notifications.create(note:"Your account got reported by a user, may be you violating some policies.")
        respond_to do |format|
            format.html { redirect_back fallback_location: view_profile_path(user.id), notice: "User reported successfully." }
        end
    end

    def flag_user
        notification = Notification.find(params[:id])
        flagged_user = User.find(params[:user_id])
        flagged_user.update_column(:flagged, true)
        user.notifications.create(note:"Your account got flagged because of some reports recieved from the users.")
        respond_to do |format|
            format.html { redirect_back fallback_location: home_show_notifications_path, notice: "User flagged successfully." }
        end
    end

    private
    def check_admin
        if current_user_role == "admin" && current_user.approved == true
            return true
        else
            return false
        end
    end

    def add_details_params
        params.require(:user).permit(:phone_no, :pan_no, :gst_no, :address)
    end
end

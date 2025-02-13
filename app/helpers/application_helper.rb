module ApplicationHelper
  def current_user_role
      role = current_user.role
  end

  def check_admin
    if current_user_role == "admin" && current_user.approved == true
        return true
    else
        return false
    end
  end
end

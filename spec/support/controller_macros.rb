module ControllerMacros
  def login_admin
    before(:each) do
      user = create(:user, role: create(:admin_role))
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      @user = user
    end
  end

  def login_user(user=nil)
    before(:each) do
      user = create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      @user = user
    end
  end
end
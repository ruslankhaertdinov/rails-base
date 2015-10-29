class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  rescue => e
    puts "*********************Error: #{e}"
  end

  private

  def build_resource(*args)
    super
    @user.apply_omniauth(session[:omniauth]) if session[:omniauth]
  end
end

class ApplicationController < ActionController::Base
  before_action :authenticate_manager!

  layout :layout_by_resource

  def current_user
    @current_user ||= current_manager 
  end

  private

  def layout_by_resource
    if current_manager
      'application'
    else
      'auth'
    end
  end
end

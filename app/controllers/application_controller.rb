class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  protected
  
  def create_cloudinary_link
    if params[:image_id].present?
      preloaded_cloudinary = Cloudinary::PreloadedFile.new(params[:image_id])
      raise "Invalid upload signature" if !preloaded_cloudinary.valid?
      return preloaded_cloudinary
    else
      return false
    end
  end
  
  
  private
  
  def current_ability
    @current_ability ||= Ability.new(current_user, params[:project_id])
  end
  
end

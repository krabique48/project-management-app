class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  
  def index
    @projects = Project.all
    @feeds = Feed.all
    @users = User.all
    if current_user
      @my_projects = current_user.projects
    end
  end
  
end

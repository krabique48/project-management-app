class WikisController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :wiki, :through => :project
  before_action :archived?, except: :show
  
  
  def new
  end
  
  def create
    if safe_create_wiki
      redirect_to @project, notice: 'Wiki was successfully created.'
    else
      render :new
    end
  end
  
  def show
    @users = User.all
  end
  
  def edit
  end
  
  def update
    if safe_update_wiki
      redirect_to project_wiki_path(@project, @wiki), 
        notice: 'Wiki was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @wiki = Wiki.find(params[:id])
    @wiki.destroy
    redirect_to @project
  end
  
  
  private
  
  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end
  
  def safe_update_wiki
    begin
      update_wiki_transaction
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end
  
  def update_wiki_transaction
    Document.transaction do
      @wiki.update!(wiki_params)
      @wiki.update!(last_editor: current_user.id)
      return true
    end
  end
  
  def safe_create_wiki
    begin
      create_wiki_transaction
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end
  
  def create_wiki_transaction
    Wiki.transaction do
      @project.wikis.create!(wiki_params)
                    .update!(creator: current_user.id)
      return true
    end
  end
  
end

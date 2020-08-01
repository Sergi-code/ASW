class AskController < ApplicationController
  
  def create
  @comments = Comment.new(post_params)
  @comments.save
  redirect_back(fallback_location: root_path)
  
end

  def destroy
 
  end
  
def show
    @submit = Submit.find(params[:id])
    @comments = Comment.where(submit_id: params[:id])
  end
end

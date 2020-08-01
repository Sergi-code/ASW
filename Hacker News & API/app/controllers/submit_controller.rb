class SubmitController < ApplicationController

 
 def index
 @submit = Submit.all.order("votes ASC").where.not(url: [nil, ""])
 end 
 
  def nuevos
   @submit = Submit.all.order("created_at ASC")
  end
 
 def ask
  @submit = Submit.where(url: [nil, ""])
 
 end

 
 
 def vote
   @submit = Submit.find(params[:id])
   if !current_user.nil?
    if !@submit.votedby.nil?
     if !@submit.votedby.include? current_user.uid
    @submit.votes = @submit.votes + 1
    @submit.votedby << current_user.uid
    @submit.save
    redirect_back(fallback_location: root_path)
   end
  else 
    @submit.votes = @submit.votes + 1
    @submit.votedby = current_user.uid
    @submit.save
    redirect_back(fallback_location: root_path)
  end
   else redirect_to "/auth/google_oauth2"
  end
  
 end
 
 def unvote
    
   if !current_user.nil?  
    @submit = Submit.find(params[:id])
    if @submit.votes > 0 
     if @submit.votedby[current_user.uid]
      @submit.votes = @submit.votes - 1
      @submit.votedby.slice! current_user.uid
      @submit.save
      redirect_back(fallback_location: root_path)
    end
   end
  else redirect_to "/auth/google_oauth2"
  end
  
 end
 
def create
 
 
  @submit = Submit.new(post_params)
  if (@submit.text.empty? && !@submit.url.empty?) ||(!@submit.text.empty? && @submit.url.empty?)
    @texterror = ''
    if Submit.where(url: @submit.url).blank? || @submit.url.empty?
     if @submit.save
      redirect_to "/nuevos"
     else 
      render 'new'
     end
    end
  else 
   @texterror = "You can't make a submission with url and text"
  end
   
  
 end
 
  def show
   @submit = Submit.find(params[:id])
  end
 
 def update
  @submit = Submit.find(params[:id])
  if @submit.update(post_params)
   redirect_to @submit
  else 
   render 'edit'
  end
 end
 
 def edit
  @submit = Submit.find(params[:id])
 end
 
 def users
  render 'users'
 end
  
 
private
  def post_params
    params.permit(:title, :url, :text, :userpost, :user_id, :votes)
  end
end
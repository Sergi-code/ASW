class RepliesController < ApplicationController
    
def vote
   @replies = Reply.find(params[:id])
   if !current_user.nil?
    if !@replies.votedby.nil?
    if !@replies.votedby[current_user.uid]
    @replies.votes = @replies.votes + 1
    @replies.votedby << current_user.uid
    @replies.save
    redirect_back(fallback_location: root_path)
   end
  else 
    @replies.votes = @replies.votes + 1
    @replies.votedby = current_user.uid
    @replies.save
    redirect_back(fallback_location: root_path)
  end
   else redirect_to "/auth/google_oauth2"
  end
  
 end
 
 def unvote
   if !current_user.nil?  
    @replies = Reply.find(params[:id])
    if @replies.votes > 0 
     if @replies.votedby[current_user.uid]
      @replies.votes = @replies.votes - 1
      @replies.votedby.slice! current_user.uid
      @replies.save
      redirect_back(fallback_location: root_path)
    end
     end
    else redirect_to "/auth/google_oauth2"
    end
  
 end
  
  
  def replies
   @replies = Reply.find(params[:id])
    @repliess = Reply.where(replyid: params[:id])
    
  end
  
  def index
  @replies = Reply.where(comment_id: id)
  end
 
  
  
  def create
  @replies = Reply.new(post_params)
  @replies.save
  redirect_back(fallback_location: root_path)
  end


  private
  def post_params
    params.permit(:text, :comment_id, :user_id, :votes, :nomautor, :replyid)
  end
  


end

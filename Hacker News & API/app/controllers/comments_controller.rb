class CommentsController < ApplicationController
  
def index
  @comments = Comment.where(submit_id: id)
end 


  def vote
   @Comments = Comment.find(params[:id])
   if !current_user.nil?
    if !@Comments.votedby.nil?
    if !@Comments.votedby.include? current_user.uid
    @Comments.votes = @Comments.votes + 1
    @Comments.votedby << current_user.uid
    @Comments.save
    redirect_back(fallback_location: root_path)
   end
  else 
    @Comments.votes = @Comments.votes + 1
    @Comments.votedby = current_user.uid
    @Comments.save
    redirect_back(fallback_location: root_path)
  end
   else redirect_to "/auth/google_oauth2"
  end
  
 end
 
 def unvote
   if !current_user.nil?  
    @Comments = Comment.find(params[:id])
    if @Comments.votes > 0 
     if @Comments.votedby[current_user.uid]
      @Comments.votes = @Comments.votes - 1
      @Comments.votedby.slice! current_user.uid
      @Comments.save
      redirect_back(fallback_location: root_path)
    end
     end
    else redirect_to "/auth/google_oauth2"
    end
  
 end


  def show
   @comments = Comment.find(params[:id])
    @replies = Reply.where(comment_id: params[:id])
  end

def create
  @comments = Comment.new(post_params)
  @comments.save
  redirect_back(fallback_location: root_path)
end

  
  private
  def post_params
    params.permit(:text, :submit_id, :user_id, :votes, :nomautor)
  end

  
end

class RepliesApiController < ApplicationController
 before_action :authenticate
  
  def get_replies
    @replies = Reply.all
    render_replies(@replies, 200)
  end
  
  def show_reply
    @reply = Reply.where(id: params[:id])
    if @reply[0] == nil
      render :json => {"Error": "Reply no existeix"}.to_json, status: 404
    else
      render_reply(@reply[0], 200)
    end
  end
  
  def comment_replies
    @replies = Reply.where(comment_id: params[:id])
    @comment = Comment.where(id: params[:id])
    if @comment[0] == nil
      render :json => {"Error": "Comment no existeix"}.to_json, status: 404
    else
      render_replies(@replies, 200)
    end
  end
  
  def user_replies
    @replies = Reply.where(user_id: params[:id])
    @user1 = User.where(id: params[:id])
    if @user1[0] == nil
      render :json => {"Error": "Usuari no existeix"}.to_json, status: 404
    else
      render_replies(@replies, 200)
    end
  end
  
  def reply_replies
    @replies = Reply.where(replyid: params[:id])
    @reply = Reply.where(id: params[:id])
    if @reply[0] == nil
      render :json => {"Error": "Reply no existeix"}.to_json, status: 404
    else
      render_replies(@replies, 200)
    end
  end
  
  def new_sub_reply
    @reply = Reply.new(post_params)
    @reply.comment_id = params[:id]
    @reply.votes = 0
    @reply.user_id = @user[0].id
    @reply.nomautor = @user[0].first_name
    
    if @reply.text == nil
      render :json => {"Error": "Una reply ha de tenir text"}, status: 400
    elsif !Comment.exists?(@reply.comment_id)
     render :json => {"Error": "Comment not found"}, status: 404
    else
      @reply.save
      render_reply(@reply, 201)
    end
  end
  
  def new_rep_reply
    @reply = Reply.new(post_params)
    @reply.replyid = params[:id]
    @reply.votes = 0
    @reply.user_id = @user[0].id
    @reply.nomautor = @user[0].first_name
    
    if @reply.text == nil
      render :json => {"Error": "Una reply ha de tenir text"}, status: 400
    elsif !Reply.exists?(@reply.replyid)
     render :json => {"Error": "Reply not found"}, status: 404
    else
      @reply.save
      render_reply(@reply, 201)
    end
  end
  
  def vote
    @reply = Reply.where(id: params[:id])
    if @reply[0] == nil
      render :json => {"Error": "Reply no existeix"}.to_json, status: 404
    else
      if !@reply[0].votedby.nil?
        if !@reply[0].votedby.include? @user[0].uid
          @reply[0].votes = @reply[0].votes + 1
          @reply[0].votedby << @user[0].uid
          @reply[0].save
        else 
          if @reply[0].votedby[@user[0].uid]
            @reply[0].votes = @reply[0].votes - 1
            @reply[0].votedby.slice! @user[0].uid
            @reply[0].save
          end
        end
      else
        @reply[0].votes = @reply[0].votes + 1
        @reply[0].votedby = @user[0].uid
        @reply[0].save
      end
      render_reply(@reply[0], 200)
    end
  end
  
  def users_votes
    @users = User.all
    @reply = Reply.where(id: params[:id])
    if @reply[0] == nil
      render :json => {"Error": "Reply no existeix"}.to_json, status: 404
    else
      @i = 0
      @vote = []
      @users.each do |u|
        
        if !@reply[0].votedby.nil?
          if @reply[0].votedby.include? (u.uid).to_s
            @vote[@i]= u
            @i = @i + 1
          end
        end
       end
       render_users(@vote, 200)
    end
  end
  
  def render_replies(replies, status)
    array = []
    replies.each do | reply |
      
      if reply.comment_id != nil
        array << {
          id: reply.id,
          content: reply.text,
          commentID: reply.comment_id,
          votes: reply.votes,
          user: reply.nomautor,
          userID: reply.user_id,
          created_at: reply.created_at
        }
      else
        array << {
          id: reply.id,
          content: reply.text,
          replyID: reply.replyid,
          votes: reply.votes,
          user: reply.nomautor,
          userID: reply.user_id,
          created_at: reply.created_at
        }
      end
      
    end
    render :json => array.to_json, status: status
  end
  
  def render_reply(reply, status)
    array = []
    
      
      if reply.comment_id != nil
        array << {
          id: reply.id,
          content: reply.text,
          commentID: reply.comment_id,
          votes: reply.votes,
          author: reply.nomautor,
          authorId: reply.user_id,
          created_at: reply.created_at
        }
      else
        array << {
          id: reply.id,
          content: reply.text,
          replyID: reply.replyid,
          votes: reply.votes,
          author: reply.nomautor,
          authorId: reply.user_id,
          created_at: reply.created_at
        }
      end
      
    render :json => array.to_json, status: status
  end
  
  def render_users(users, status)
    array = []
    users.each do | user |
      array << {
        id: user.id,
        email: user.email,
        name: user.first_name,
        about: user.string,
        created_at: user.created_at
      }
    end
    render :json => array.to_json, status: status
  end
  
  private
  def post_params
    params.permit(:text, :comment_id, :user_id, :votes, :nomautor, :replyid)
  end
end
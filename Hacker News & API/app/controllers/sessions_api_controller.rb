class SessionsApiController < ApplicationController
 before_action :authenticate

  def get_users
    @users = User.all
    render_users(@users, 200)
  end
  
  def show_user
    @user1 = User.where(id: params[:id])
    if @user1[0] == nil
      render :json => {"Error": "User no existeix"}.to_json, status: 404
    else
      render_user(@user[0],200)
    end
  end
  
  def user_votes
    @submits = Submit.all
    @user1 = User.where(id: params[:id])
    if @user1[0] == nil
      render :json => {"Error": "User no existeix"}.to_json, status: 404
    else
      @i = 0
      @sub_votes = []
      @submits.each do |sub|
        if !sub.votedby.nil?
          if sub.votedby.include? @user1[0].uid
            @sub_votes[@i]= sub
            @i = @i + 1
          end
        end
      end
      
      @comments = Comment.all
      @i = 0
      @com_votes = []
      @comments.each do |com|
        if !com.votedby.nil?
          if com.votedby.include? @user1[0].uid
            @com_votes[@i]= com
            @i = @i + 1
          end
        end
      end
       
      @replies = Reply.all
      @i = 0
      @rep_votes = []
      @replies.each do |rep|
        if !rep.votedby.nil?
          if rep.votedby.include? @user1[0].uid
            @rep_votes[@i]= rep
            @i = @i + 1
          end
        end
      end
      
      render_votes(@sub_votes, @com_votes, @rep_votes, 200)
    end
  end

  def update_about
    @user1 = User.where(id: params[:id])
    if @user1[0] == nil
      render :json => {"Error": "User no existeix"}.to_json, status: 404
    else
      if @user1[0].id == @user[0].id
        @user1[0].string = params[:about]
        @user1[0].save
        render_user(@user1[0], 200)
      else 
       render :json => {"Error": "Unauthorized user"}.to_json, status: 401
      end
    end
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
  
  def render_user(user, status)
    array = []
    
    array << {
      id: user.id,
      email: user.email,
      name: user.first_name,
      about: user.string,
      created_at: user.created_at
    }
    render :json => array.to_json, status: status
  end
  
  def render_votes(submits, comments, replies, status)
    array = []
    array << {Submits: ''}
    if submits != nil
      submits.each do | sub |
        
        if sub.text.length == 0
          @content = sub.url
        else 
          @content = sub.text
        end
      
        array << {
          id: sub.id,
          title: sub.title,
          content: @content,
          votes: sub.votes,
          user: sub.userpost,
          userId: sub.user_id,
          created_at: sub.created_at
        }
      end
    end
    
    array << {Comments: ''}
    if comments != nil
      comments.each do | com |
        array << {
          id: com.id,
          content: com.text,
          submitID: com.submit_id,
          votes: com.votes,
          author: com.nomautor,
          authorId: com.user_id,
          created_at: com.created_at
        }
      end
    end
    
    array << {Replies: ''}
    
    if replies != nil
      replies.each do | rep |
        if rep.comment_id != nil
          array << {
            id: rep.id,
            content: rep.text,
            commentID: rep.comment_id,
            votes: rep.votes,
            author: rep.nomautor,
            authorId: rep.user_id,
            created_at: rep.created_at
          }
        else
          array << {
            id: rep.id,
            content: rep.text,
            replyID: rep.replyid,
            votes: rep.votes,
            author: rep.nomautor,
            authorId: rep.user_id,
            created_at: rep.created_at
          }
        end
      end
    end
    render :json => array.to_json, status: status
  end
    
  private
    def post_params
      params.permit(:about)
    end
end

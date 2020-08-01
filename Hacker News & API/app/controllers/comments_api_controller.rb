class CommentsApiController < ApplicationController
 before_action :authenticate
  
  def get_comments
    @comments = Comment.all
    render_comments(@comments,200)
  end 
  
  def show_comment
    @comment = Comment.where(id: params[:id])
    if @comment[0] == nil
      render :json => {"Error": "Comment no existeix"}.to_json, status: 404
    else
      render_comment(@comment[0], 200)
    end
  end
  
  def submit_comments
    @comments = Comment.where(submit_id: params[:id])
    if @comments[0] == nil
      render :json => {"Error": "Comment no existeix"}.to_json, status: 404
    else
      render_comments(@comments, 200)
    end
  end
  
  def user_comments
    @comments = Comment.where(user_id: params[:id])
    @user1 = User.where(id: params[:id])
    if @user1[0] == nil
      render :json => {"Error": "User no existeix"}.to_json, status: 404
    else
      render_comments(@comments, 200)
    end
  end
  
  def new_comment
    @comment = Comment.new(post_params)
    @comment.submit_id = params[:id]
    @comment.votes = 0
    @comment.user_id = @user[0].id
    @comment.nomautor = @user[0].first_name
    
    if @comment.text == nil
      render :json => {"Error": "El comentari ha de tenir text"}, status: 400
    elsif !Submit.exists?(@comment.submit_id)
     render :json => {"Error": "Submit not found"}, status: 404
    else
      @comment.save
      render_comment(@comment, 201)
    end
  end
  
  def vote
    @comment = Comment.where(id: params[:id])
    if @comment[0] == nil
      render :json => {"Error": "Comment no existeix"}.to_json, status: 404
    else
      if !@comment[0].votedby.nil?
        if !@comment[0].votedby.include? @user[0].uid
          @comment[0].votes = @comment[0].votes + 1
          @comment[0].votedby << @user[0].uid
          @comment[0].save
        else 
          if @comment[0].votedby[@user[0].uid]
            @comment[0].votes = @comment[0].votes - 1
            @comment[0].votedby.slice! @user[0].uid
            @comment[0].save
          end
        end
      else
        @comment[0].votes = @comment[0].votes + 1
        @comment[0].votedby = @user[0].uid
        @comment[0].save
      end
      render_comment(@comment[0], 200)
    end
  end
  
  def users_votes
    @users = User.all
    @comment = Comment.where(id: params[:id])
    if @comment[0] == nil
      render :json => {"Error": "Comment no existeix"}.to_json, status: 404
    else
      @i = 0
      @vote = []
      @users.each do |u|
        
        if !@comment[0].votedby.nil?
          if @comment[0].votedby.include? (u.uid).to_s
            @vote[@i]= u
            @i = @i + 1
          end
        end
       end
       render_users(@vote, 200)
    end
  end
  
  def render_comments(comments, status)
    array = []
    comments.each do | comment |
      array << {
        id: comment.id,
        content: comment.text,
        submitID: comment.submit_id,
        votes: comment.votes,
        user: comment.nomautor,
        userID: comment.user_id,
        created_at: comment.created_at
      }
    end
    render :json => array.to_json, status: status
  end
  
  def render_comment(comment, status)
    array = []
    
    array << {
      id: comment.id,
      content: comment.text,
      submitID: comment.submit_id,
      votes: comment.votes,
      user: comment.nomautor,
      userID: comment.user_id,
      created_at: comment.created_at
    }
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
    params.permit(:text, :submit_id, :user_id, :votes, :nomautor)
  end
end

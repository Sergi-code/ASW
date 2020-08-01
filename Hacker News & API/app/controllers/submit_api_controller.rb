class SubmitApiController < ApplicationController
  before_action :authenticate

  def get_submits
    tipus = params[:type]
    if (tipus == nil)
      @submits = Submit.all.order("created_at DESC")
      render_submits(@submits, 200)
    elsif (tipus == 'url') 
      @submits = Submit.all.order("votes ASC").where.not(url: [nil, ""])
      render_submits(@submits, 200)
    elsif (tipus == 'ask')
      @submits = Submit.where(url: [nil, ""])
      render_submits(@submits, 200)
    else
      render :json => {"Error": "Tipus no existeix"}.to_json, status: 400
    end
  end
  
  def show_submit
    @submit = Submit.where(id: params[:id])
    if @submit[0] == nil
      render :json => {"Error": "Submit no existeix"}.to_json, status: 404
    else
      render_submit(@submit[0], 200)
    end
  end
  
  def user_submits
    @submits = Submit.where(user_id: params[:id])
    @user1 = User.where(id: params[:id])
    if @user1[0] == nil
      render :json => {"Error": "Usuari no existeix"}.to_json, status: 404
    else
      render_submits(@submits, 200)
    end
  end
  
  def new_submit
    @submit = Submit.new(post_params)
    @submit.votes = 0
    @submit.user_id = @user[0].id
    @submit.userpost = @user[0].first_name
    
    if @submit.url.length != 0 && @submit.text.length != 0
      render :json => {"Error": "Un submit no pot tenir url i text"}.to_json, status: 400
    elsif @submit.url.length == 0 && @submit.text.length == 0
      render :json => {"Error": "Un submit ha de tenir url o text"}.to_json, status: 400
    else
      if @submit.url.length != 0
        @copia = Submit.where(url: @submit.url)
        if @copia.size >= 1
          render_submit(@copia[0], 409)
        else 
        @submit.save
        render_submit(@submit, 201)
        end
      else 
      @submit.save
      render_submit(@submit, 201)
      end
    end
  end
  
  def users_votes
    @users = User.all
    @submit = Submit.where(id: params[:id])
    @i = 0
    @vote = []
    if @submit[0] == nil
      render :json => {"Error": "Submit no existeix"}.to_json, status: 404
    else
      @users.each do |u|
        
        if !@submit[0].votedby.nil?
          if @submit[0].votedby.include? (u.uid).to_s
            @vote[@i]= u
            @i = @i + 1
          end
        end
      end
      render_users(@vote, 200)
    end
  end
  
  def vote
    @submit = Submit.where(id: params[:id])
    if @submit[0] == nil
      render :json => {"Error": "Submit no existeix"}.to_json, status: 404
    else
      if !@submit[0].votedby.nil?
        if !@submit[0].votedby.include? @user[0].uid
          @submit[0].votes = @submit[0].votes + 1
          @submit[0].votedby << @user[0].uid
          @submit[0].save
        else 
          if @submit[0].votedby[@user[0].uid]
            @submit[0].votes = @submit[0].votes - 1
            @submit[0].votedby.slice! @user[0].uid
            @submit[0].save
          end
        end
      else
        @submit[0].votes = @submit[0].votes + 1
        @submit[0].votedby = @user[0].uid
        @submit[0].save
      end
      render_submit(@submit[0], 200)
    end
  end
  
  def render_submits(submits, status)
    array = []
    
    submits.each do | submit |
      
      if submit.text.length == 0
        @content = submit.url
      else 
        @content = submit.text
      end
    
      array << {
        id: submit.id,
        title: submit.title,
        content: @content,
        votes: submit.votes,
        user: submit.userpost,
        userID: submit.user_id,
        created_at: submit.created_at
      }
    end
    render :json => array.to_json, status: status
  end
  
  def render_submit(submit, status)
    array = []
    
    if submit.text.length == 0
      @content = submit.url
    else 
      @content = submit.text
    end
    
    array << {
      id: submit.id,
      title: submit.title,
      content: @content,
      votes: submit.votes,
      user: submit.userpost,
      userID: submit.user_id,
      created_at: submit.created_at
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
      params.permit(:title, :url, :text, :userpost, :user_id, :votes)
    end
end

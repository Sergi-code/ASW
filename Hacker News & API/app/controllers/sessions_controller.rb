class SessionsController < ApplicationController
  
  
  def submissions
    @submit = Submit.where(user_id: params[:id])
  end
  
  def comments
    @comments = Comment.where(user_id: params[:id])
    @submits = Submit.all
  end
  
  def votes
    @submits = Submit.all
    @i = 0
    @vote = []
    @submits.each do |sub|
      
      if !sub.votedby.nil?
        if sub.votedby.include? params[:id]
          @vote[@i]= sub
          @i = @i + 1
        end
      end
     end
  end
  
  
  def votedcom
    @submits = Comment.all
    @i = 0
    @vote = []
    @submits.each do |sub|
      
      if !sub.votedby.nil?
        if sub.votedby.include? params[:id]
          @vote[@i]= sub
          @i = @i + 1
        end
      end
      
     
     end
     
      @submit = Submit.all
  end
  
  
  def create
  	@user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"])
  	session[:user_id] = @user.id
  	redirect_to root_path
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_path
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def update
    
    if params[:id] == params[:user_id]
    @session = User.find(params[:user_id])
     #@session.update(string: params[:session][:string])
      #@session.update(params[:session])
    
    @session.string = params[:string]
    @session.save
    redirect_back(fallback_location: root_path)
    
   else redirect_back(fallback_location: root_path)
     end
    
  end
  
  private 
    def user_params
       params.require(:user)
    end
end
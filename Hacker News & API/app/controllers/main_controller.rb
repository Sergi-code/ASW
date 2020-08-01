class MainController < ApplicationController
  
  def index
    @submits = Submit.all.order("created_at DESC")
  end
  
end

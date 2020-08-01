Rails.application.routes.draw do
  
 
  resources :comments do
   member do
      put 'vote'
    end
    member do
      put 'unvote'
    end
  end
  
  resources :submit do
    member do
      put 'vote'
    end
    member do
      put 'unvote'
    end
  end
  
  resources :replies do
    member do
      put 'vote'
    end
    member do
      put 'unvote'
    end
  end
  
  get 'replies', to:'replies#create'
  get 'updateses' , to: 'sessions#update'
  get 'reply/:id', to: 'replies#replies'
  get 'signin', to: 'sessions#redirecciona'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get 'users/:id', to: 'sessions#show'
  get 'submits/:id', to: 'ask#show'
  get 'ask', to: 'submit#ask'
  get 'nuevos', to: 'submit#nuevos'
  get 'comment/:id', to: 'comments#show'
  get 'users/submissions/:id', to: 'sessions#submissions'
  get 'users/comments/:id', to: 'sessions#comments'
  get 'users/votes/:id' , to: 'sessions#votes'
  get 'users/votedcomments/:id' , to: 'sessions#votedcom'
  
  # API 
  
  get 'api/users', to: 'sessions_api#get_users'
  get 'api/user/:id', to: 'sessions_api#show_user'
  
  get 'api/submits', to: 'submit_api#get_submits'
  get 'api/submit/:id', to: 'submit_api#show_submit'
  get 'api/submit/:id/comments', to: 'comments_api#submit_comments'
  
  get 'api/comments', to: 'comments_api#get_comments'
  get 'api/comment/:id', to: 'comments_api#show_comment'
  get 'api/comment/:id/replies', to: 'replies_api#comment_replies'
  
  get 'api/replies', to: 'replies_api#get_replies'
  get 'api/reply/:id', to: 'replies_api#show_reply'
  get 'api/reply/:id/replies', to: 'replies_api#reply_replies'
  
  get 'api/user/:id/submits', to: 'submit_api#user_submits'
  get 'api/user/:id/comments', to: 'comments_api#user_comments'
  get 'api/user/:id/replies', to: 'replies_api#user_replies'
  get 'api/user/:id/votes', to: 'sessions_api#user_votes'
  
  get 'api/submit/:id/voters', to: 'submit_api#users_votes'
  get 'api/comment/:id/voters', to: 'comments_api#users_votes'
  get 'api/reply/:id/voters', to: 'replies_api#users_votes'
  
  put 'api/user/:id', to: 'sessions_api#update_about'
  
  post 'api/submits', to: 'submit_api#new_submit'
  post 'api/submit/:id/comments', to: 'comments_api#new_comment'
  post 'api/comment/:id/replies', to: 'replies_api#new_sub_reply'
  post 'api/reply/:id/replies', to: 'replies_api#new_rep_reply'
  
  put 'api/submit/:id/vote', to: 'submit_api#vote'
  put 'api/comment/:id/vote', to: 'comments_api#vote'
  put 'api/reply/:id/vote', to: 'replies_api#vote'
  
  root 'submit#index'
end



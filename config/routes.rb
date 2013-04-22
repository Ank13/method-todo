MethodTodo::Application.routes.draw do
  devise_for :users

  match 'toggle_help' => 'frontpage#toggle_help'
  match 'timezone' => 'frontpage#set_timezone', via: :post

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  resources :todos do
    member do
      put 'complete'
    end
  end

  resources :todo_contexts, :path => :contexts, :as => :contexts

  resources :projects

  resources :tags

  root :to => 'frontpage#index'
end

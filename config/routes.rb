Rails.application.routes.draw do
  get 'welcome/index'
  post 'welcome/index'
  get 'welcome/show'

  root 'welcome#index'
end

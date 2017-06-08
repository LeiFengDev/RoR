Rails.application.routes.draw do
  get 'payment/index'
  get "payment" => "payment#index"

  resources :employees, :workgroups, :dailyworks

  root 'payment#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

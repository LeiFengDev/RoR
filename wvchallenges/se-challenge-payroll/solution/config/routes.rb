Rails.application.routes.draw do
  get 'payment/index'
  get 'payment' => 'payment#index'

  get 'timesheet/index'
  get 'timesheet/upload'
  post 'timesheet/create'
  get 'timesheet' => 'timesheet#index'

  resources :employees, :workgroups, :dailyworks, :timesheet_status

  root 'payment#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

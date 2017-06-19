Rails.application.routes.draw do
  get 'report/index', to: 'report#index', default: { pay_period: 'semimonthly' }
  get 'report(/start/:start_datetime)(/end/:end_datetime)(/group/:workgroup_id)(/employee/:employee_id)(/period/:pay_period)', to: 'report#index', default: { pay_period: 'semimonthly' }
  get 'report/json(/start/:start_datetime)(/end/:end_datetime)(/group/:workgroup_id)(/employee/:employee_id)(/period/:pay_period)', to: 'report#show_json', default: { pay_period: 'semimonthly' }

  get 'timesheet/index'
  get 'timesheet/upload'
  post 'timesheet/create'
  get 'timesheet' => 'timesheet#index'

  resources :employees, :workgroups, :dailyworks, :timesheet_status

  root to: 'report#index', default: { pay_period: 'semimonthly' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

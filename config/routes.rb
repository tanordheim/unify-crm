Unify::Application.routes.draw do

  if Rails.env.development?

    require 'resque/server'
    mount Resque::Server.new, at: '/resque'

    get '/email_test' => 'email_test#show'

  end

  # Single sign on.
  # ---------------------------------------------------------------------------
  get '/sso/:application_key/new' => 'single_signon#new'
  post '/sso/:application_key' => 'single_signon#create', as: :single_signon

  # Unify REST API.
  # ---------------------------------------------------------------------------
  namespace :api do
    resources :organizations, only: [:index, :show]
    resources :users, only: [:show]
  end

  # Github service hooks.
  # ---------------------------------------------------------------------------
  scope '/github' do
    post '/service_hook' => 'github/service_hook#create'
  end

  # Unify UI.
  # ---------------------------------------------------------------------------
  resource :session, only: [:new, :create, :destroy]

  root to: 'dashboard#index'
  get '/dashboard' => 'dashboard#index', as: :dashboard
  resources :dashboard_widgets, only: [:new, :create, :destroy] do
    post :reorder, on: :collection
  end

  resource :instance, only: [:show, :update]

  resources :comments, only: [:new, :create] do
    get '/:commentable_type/:commentable_id', controller: :comments, action: :index, on: :collection
  end

  resources :events, only: [:new, :create, :edit, :update, :show]
  resources :event_categories

  get '/calendar(/:year(/:month(/:day)))' => 'calendar#index', constraints: { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }, as: :calendar

  resources :contacts, only: [:index]
  resources :people, only: [:show, :new, :create, :update, :destroy] do
    get :typeahead, on: :collection
    post :restore, on: :member
    resources :employments, only: [:index, :create, :update, :destroy]
    resources :phone_numbers, only: [:index, :create, :update, :destroy]
    resources :email_addresses, only: [:index, :create, :update, :destroy]
    resources :websites, only: [:index, :create, :update, :destroy]
    resources :twitter_accounts, only: [:index, :create, :update, :destroy]
    resources :instant_messengers, only: [:index, :create, :update, :destroy]
    resources :addresses, only: [:index, :create, :update, :destroy]
  end
  resources :organizations, only: [:show, :new, :create, :update, :destroy] do
    get :typeahead, on: :collection
    post :restore, on: :member
    resources :employees, only: [:index, :create, :update, :destroy]
    resources :phone_numbers, only: [:index, :create, :update, :destroy]
    resources :email_addresses, only: [:index, :create, :update, :destroy]
    resources :websites, only: [:index, :create, :update, :destroy]
    resources :twitter_accounts, only: [:index, :create, :update, :destroy]
    resources :instant_messengers, only: [:index, :create, :update, :destroy]
    resources :addresses, only: [:index, :create, :update, :destroy]
  end

  resources :deals, only: [:index, :show, :new, :create, :update]
  resources :deal_categories, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :deal_stages, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :sources, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :projects do
    post :restore, on: :member, as: :restore
    resources :components, only: [:index, :new, :create, :edit, :update]
    resources :milestones do
      post :restore, on: :member, as: :restore
      get :change_log, on: :member
      post :notify, on: :member
    end
    resources :tickets, only: [:index, :show, :new, :create, :edit, :update] do
      post :reopen, on: :member
      post :start_progress, on: :member
      post :stop_progress, on: :member
      post :close, on: :member
      put :inline_update, on: :member
      post :set_milestone, on: :collection, as: :set_milestone
      post :set_priority, on: :collection, as: :set_priority
      post :set_user, on: :collection, as: :set_user
    end
    resources :pages, only: [:index, :show, :new, :create, :edit, :update]
  end
  resources :project_categories, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :ticket_categories, only: [:index, :new, :create, :edit, :update, :destroy]

  get '/accounting' => 'accounting#index', as: :accounting
  resources :invoices, only: [:index, :show, :new, :create, :edit, :update] do
    get :generate_pdf, on: :member
    post :generate, on: :member
    resources :payments, controller: 'invoice_payments', only: [:new, :create]
  end
  resources :ledger_transactions, only: [:index, :show, :new, :create, :edit, :update]
  get '/ledger_transactions/:ledger_transaction_id/attachments/:id' => 'ledger_transaction_attachments#show', as: :download_ledger_transaction_attachment
  resources :accounts, only: [:index, :new, :create, :edit, :update]
  resources :organization_accounts, only: [:index]
  resources :tax_codes, only: [:index, :new, :create, :edit, :update]
  resources :products, only: [:index, :new, :create, :edit, :update]
  resources :payment_forms, only: [:index, :new, :create, :edit, :update]

  resources :api_applications, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :users, only: [:index, :show, :new, :create, :edit, :update]
  
end

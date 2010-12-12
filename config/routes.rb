RemoteJobs::Application.routes.draw do
  resources :job_postings,  :path => "/jobs" 

  match '/preview',         :to => 'job_postings#preview', :method => :post
  match '/publish/:uid',    :to => 'job_postings#publish', :method => :put

  match '/filter',          :to => 'search#filter'

  match '/edit/:uid',       :to => 'job_postings#edit'
  match '/disable/:uid',    :to => 'job_postings#disable'
  
  match '/privacy',         :to => 'pages#privacy'
  match '/refunds',         :to => 'pages#refunds'

  match '/',                :to => 'job_postings#index',              :as => 'root'
end

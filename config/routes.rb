RemoteJobs::Application.routes.draw do
  resources :job_postings,  :path => "/jobs"

  match '/preview/:uid',    :to => 'job_postings#preview', :as => :preview
  match '/publish/:uid',    :to => 'job_postings#publish', :method => :put, :as => :publish
  match '/edit/:uid',       :to => 'job_postings#edit', :as => :edit
  match '/disable/:uid',    :to => 'job_postings#disable', :as => :disable

  match '/filter',          :to => 'search#filter'
  
  match '/privacy',         :to => 'pages#privacy'
  match '/refunds',         :to => 'pages#refunds'
  match '/story',           :to => 'pages#story'

  match '/',                :to => 'job_postings#index',              :as => 'root'
end

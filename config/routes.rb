RemoteJobs::Application.routes.draw do

  resources :jobs

  match '/',                :to => 'job_postings#index',              :as => 'root'
end

RemoteJobs::Application.routes.draw do

  resources :job_postings

  match '/',                :to => 'job_postings#index',              :as => 'root'
end

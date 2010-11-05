RemoteJobs::Application.routes.draw do

  resources :job_postings

  match '/edit/:uuid',      :to => 'job_postings#edit'

  match '/',                :to => 'job_postings#index',              :as => 'root'
end

RemoteJobs::Application.routes.draw do
  resources :job_postings,  :path => "/jobs"

  match '/filter',          :to => 'search#filter'

  match '/edit/:uuid',      :to => 'job_postings#edit'
  match '/disable/:uuid',   :to => 'job_postings#disable'

  match '/',                :to => 'job_postings#index',              :as => 'root'
end

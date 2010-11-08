RemoteJobs::Application.routes.draw do
  resources :job_postings,  :path => "/jobs"

  match '/search',          :to => 'search#search'
  match '/filter',          :to => 'search#filter'

  match '/edit/:uuid',      :to => 'job_postings#edit'
  match '/disable/:uuid',   :to => 'job_postings#disable'

  match '/design',          :to => 'job_postings#design'
  match '/development',     :to => 'job_postings#development'
  match '/copywriting',     :to => 'job_postings#copywriting'
  match '/management',      :to => 'job_postings#management'

  match '/',                :to => 'job_postings#index',              :as => 'root'
end

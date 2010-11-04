RemoteJobs::Application.routes.draw do

  match '/',                :to => 'job_postings#index',              :as => 'root'
end

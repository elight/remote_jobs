class JobPostingsController < InheritedResources::Base
  respond_to :html
  actions :all, :except => :destroy
end

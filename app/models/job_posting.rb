class JobPosting < ActiveRecord::Base
  validates_presence_of :title, :description, :contractor, :hourly, :how_to_apply, :hiring_criteria, :category

  belongs_to :customer
end

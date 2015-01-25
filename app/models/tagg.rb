class Tagg < ActiveRecord::Base
  belongs_to :taggable, :polymorphic => true
  belongs_to :user
  
  validates_associated :taggable
  validates_associated :user
end

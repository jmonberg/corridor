class TotemEvent < ActiveRecord::Base
  belongs_to :action, :polymorphic => true
end

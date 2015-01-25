namespace :feeds do
  task :update => :environment do
    Feed.find(:all).each {|a| a.pull }
  end
end
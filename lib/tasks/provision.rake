namespace :provision do
  desc 'Provision a Heroku based deployment.'
  task heroku: :environment do
    Rails.logger.debug 'Heorku ENV:'
    Rails.logger.debug ENV.inspect
  end
end

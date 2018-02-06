namespace :provision do
  desc 'Provision a Heroku based deployment.'
  task heroku: :environment do
    puts 'Heorku ENV:'
    pp ENV
  end
end

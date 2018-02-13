require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  sequence :uuid do |n|
    SecureRandom.uuid
  end
end

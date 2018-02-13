module API
  module V1
    class BaseResourceController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      jsonapi_resources(:schemas, except: :destroy){ jsonapi_relationships }
      jsonapi_resources(:schema_versions){ jsonapi_relationships }
    end
  end

  mount_ember_app :frontend, to: '/'
end

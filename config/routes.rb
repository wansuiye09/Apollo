Rails.application.routes.draw do
  # Last route - catch all for Elm
  get '*other', to: 'static#index'
end

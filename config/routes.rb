Rails.application.routes.draw do
  # Last route - catch all for Elm
  get '*other', to: 'main#index'
end

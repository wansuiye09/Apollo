Rails.application.routes.draw do
  root 'static#main'
  # Last route - catch all for Elm
  get '*other', to: 'static#main'
end

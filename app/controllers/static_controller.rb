class StaticController < Rails::ApplicationController
  def main
    if Rails.env.production?
      render file: Rails.root.join('public', 'main.html')
    else
      redirect_to ENV['MAIN_APP_URL']
    end
  end
end

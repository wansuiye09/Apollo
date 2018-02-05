class StaticController < ApplicationController
  def main
    if Rails.env.production?
      render file: Rails.root.join('public', 'main.html')
    else
      render html: Net::HTTP.get(URI(ENV['MAIN_APP_URL'])).html_safe
    end
  end
end

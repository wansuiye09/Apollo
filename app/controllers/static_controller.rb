class StaticController < Rails::ApplicationController
  def main
    render file: Rails.root.join('public', 'main.html')
  end
end

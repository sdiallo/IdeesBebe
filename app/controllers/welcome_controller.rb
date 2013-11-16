class WelcomeController < ApplicationController
  def index
  end

  def forbidden
    render :file => 'public/422.html', :status => :forbidden
  end
end

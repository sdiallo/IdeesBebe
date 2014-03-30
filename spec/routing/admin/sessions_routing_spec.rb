require 'spec_helper'

describe Admin::SessionsController do
  describe 'Routing' do

    it 'routes to #new' do
      get('/admin').should route_to('admin/sessions#new')
    end

    it 'routes to #create' do
      post('/admin').should route_to('admin/sessions#create')
    end
  end
end
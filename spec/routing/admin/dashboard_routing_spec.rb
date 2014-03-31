require 'spec_helper'

describe Admin::DashboardController do
  describe 'Routing' do

    it 'routes to #index' do
      get('/admin/dashboard').should route_to('admin/dashboard#index')
    end
  end
end
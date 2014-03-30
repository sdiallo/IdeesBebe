require 'spec_helper'

describe Admin::ProductsController do
  describe 'Routing' do

    it 'routes to #index' do
      get('/admin/products').should route_to('admin/products#index')
    end
  end
end
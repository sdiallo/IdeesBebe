require 'spec_helper'

describe ReportsController do
  describe 'Routing' do

    it 'routes to #create' do
      post('/products/1/reports').should route_to('reports#create', product_id: '1')
    end
  end
end
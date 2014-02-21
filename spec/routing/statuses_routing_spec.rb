require "spec_helper"

describe StatusController do
  describe "Routing" do

    it "routes to #index" do
      get("/products/1/status").should route_to("status#index", product_id: '1')
    end


    it "routes to #show" do
      get("/products/1/status/2").should route_to("status#show", product_id: '1', id: '2')
    end
  end
end
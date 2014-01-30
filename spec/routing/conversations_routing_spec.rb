require "spec_helper"

describe ConversationsController do
  describe "Routing" do

    it "routes to #index" do
      get("/products/1/conversations").should route_to("conversations#index", product_id: '1')
    end

    it "routes to #show" do
      get("/products/1/conversations/1").should route_to("conversations#show", product_id: '1', id: '1' )
    end
  end
end
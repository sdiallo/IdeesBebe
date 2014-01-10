require "spec_helper"

describe ProductAssetsController do
  describe "Routing" do

    it "routes to #destroy" do
      delete("/product_assets/1").should route_to("product_assets#destroy", id: "1")
    end

    it "routes to #update" do
      put("/product_assets/1").should route_to("product_assets#update", id: "1")
    end

    it "routes to #create" do
      post("/products/1/product_assets").should route_to("product_assets#create", product_id: "1")
    end
  end
end
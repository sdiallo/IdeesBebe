require "spec_helper"

describe ProductAssetsController do
  describe "Routing" do

    it "routes to #destroy" do
      delete("/product_assets/1").should route_to("product_assets#destroy", id: "1")
    end

    it "routes to #become_starred" do
      put("/product_assets/1").should route_to("product_assets#update", id: "1")
    end
  end
end
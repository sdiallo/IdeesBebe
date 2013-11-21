require "spec_helper"

describe AssetsController do
  describe "Routing" do

    it "routes to #destroy" do
      delete("/assets/1").should route_to("assets#destroy", id: "1")
    end

    it "routes to #become_starred" do
      put("/assets/1").should route_to("assets#become_starred", id: "1")
    end
  end
end
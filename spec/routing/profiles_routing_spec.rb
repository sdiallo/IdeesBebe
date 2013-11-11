require "spec_helper"

describe ProfilesController do
  describe "Routing" do

    it "routes to #show" do
      get("/profiles/test").should route_to("profiles#show", :id => "test")
    end

    it "routes to #edit" do
      get("/profiles/test/edit").should route_to("profiles#edit", :id => "test")
    end

    it "routes to #update" do
      put("/profiles/test").should route_to("profiles#update", :id => "test")
    end

    it "routes to #destroy" do
      delete("/profiles/test").should route_to("profiles#destroy", :id => "test")
    end

  end
end
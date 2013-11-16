require "spec_helper"

describe ProductsController do
  describe "Routing" do

    it "routes to #index" do
      get("/profiles/test/products").should route_to("products#index", profile_id: "test")
    end

    it "routes to #new" do
      get("/profiles/test/products/new").should route_to("products#new", profile_id: "test")
    end

    it "routes to #create" do
      post("/profiles/test/products").should route_to("products#create", profile_id: "test")
    end

    it "routes to #show" do
      get("/products/t-products").should route_to("products#show", id: "t-products")
    end

    it "routes to #edit" do
      get("/products/t-products/edit").should route_to("products#edit", id: "t-products")
    end

    it "routes to #update" do
      put("/products/t-products").should route_to("products#update", id: "t-products")
    end

    it "routes to #destroy" do
      delete("products/t-products").should route_to("products#destroy", id: "t-products")
    end

  end
end
require "spec_helper"

describe MessagesController do
  describe "Routing" do

    it "routes to #create" do
      post("/messages").should route_to("messages#create")
    end
  end
end
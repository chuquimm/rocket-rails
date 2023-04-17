require "test_helper"
require "generators/resource_route/resource_route_generator"

class ResourceRouteGeneratorTest < Rails::Generators::TestCase
  tests ResourceRouteGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
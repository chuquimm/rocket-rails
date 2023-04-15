require "test_helper"
require "generators/scaffold_services/scaffold_services_generator"

class ScaffoldServicesGeneratorTest < Rails::Generators::TestCase
  tests ScaffoldServicesGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end

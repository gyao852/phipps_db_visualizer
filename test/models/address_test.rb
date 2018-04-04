require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # Relationship matchers...
    should belong_to(:constituent)
  # Validation matchers...

  # test "the truth" do
  #   assert true
  # end
end

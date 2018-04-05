require 'test_helper'

class ContactHistoryTest < ActiveSupport::TestCase
	should belong_to(:constituent)
  # test "the truth" do
  #   assert true
  # end
end

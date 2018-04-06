require 'test_helper'

class DonationHistoryTest < ActiveSupport::TestCase
  should belong_to(:constituent)
  should belong_to(:donation_program)
  # test "the truth" do
  #   assert true
  # end
end

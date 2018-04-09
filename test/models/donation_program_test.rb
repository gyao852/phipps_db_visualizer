require 'test_helper'

class DonationProgramTest < ActiveSupport::TestCase

	# Testing other methods with a context
	context "Creating a donation program context" do
		setup do
			@dp1 = FactoryBot.create(:donation_program)
		end

		# and provide a teardown method as well
		teardown do
			@dp1.destroy()
		end

		# test the scope 'for_program'
		should "shows that searching by term for program works" do
			assert_equal ['Total Contributions \ Operating \ Discovery Garden Bricks'],
			DonationProgram.for_program("Garden Bricks").map{|p| p.program}
		end
	end
end

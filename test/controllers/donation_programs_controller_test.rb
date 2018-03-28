require 'test_helper'

class DonationProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @donation_program = donation_programs(:one)
  end

  test "should get index" do
    get donation_programs_url
    assert_response :success
  end

  test "should get new" do
    get new_donation_program_url
    assert_response :success
  end

  test "should create donation_program" do
    assert_difference('DonationProgram.count') do
      post donation_programs_url, params: { donation_program: { active: @donation_program.active, donation_program_id: @donation_program.donation_program_id, program: @donation_program.program } }
    end

    assert_redirected_to donation_program_url(DonationProgram.last)
  end

  test "should show donation_program" do
    get donation_program_url(@donation_program)
    assert_response :success
  end

  test "should get edit" do
    get edit_donation_program_url(@donation_program)
    assert_response :success
  end

  test "should update donation_program" do
    patch donation_program_url(@donation_program), params: { donation_program: { active: @donation_program.active, donation_program_id: @donation_program.donation_program_id, program: @donation_program.program } }
    assert_redirected_to donation_program_url(@donation_program)
  end

  test "should destroy donation_program" do
    assert_difference('DonationProgram.count', -1) do
      delete donation_program_url(@donation_program)
    end

    assert_redirected_to donation_programs_url
  end
end

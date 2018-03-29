require 'test_helper'

class ConstituentMembershipRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @constituent_membership_record = constituent_membership_records(:one)
  end

  test "should get index" do
    get constituent_membership_records_url
    assert_response :success
  end

  test "should get new" do
    get new_constituent_membership_record_url
    assert_response :success
  end

  test "should create constituent_membership_record" do
    assert_difference('ConstituentMembershipRecord.count') do
      post constituent_membership_records_url, params: { constituent_membership_record: { lookup_id: @constituent_membership_record.lookup_id, membership_id: @constituent_membership_record.membership_id } }
    end

    assert_redirected_to constituent_membership_record_url(ConstituentMembershipRecord.last)
  end

  test "should show constituent_membership_record" do
    get constituent_membership_record_url(@constituent_membership_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_constituent_membership_record_url(@constituent_membership_record)
    assert_response :success
  end

  test "should update constituent_membership_record" do
    patch constituent_membership_record_url(@constituent_membership_record), params: { constituent_membership_record: { lookup_id: @constituent_membership_record.lookup_id, membership_id: @constituent_membership_record.membership_id } }
    assert_redirected_to constituent_membership_record_url(@constituent_membership_record)
  end

  test "should destroy constituent_membership_record" do
    assert_difference('ConstituentMembershipRecord.count', -1) do
      delete constituent_membership_record_url(@constituent_membership_record)
    end

    assert_redirected_to constituent_membership_records_url
  end
end

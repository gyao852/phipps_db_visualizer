require 'test_helper'

class MembershipRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership_record = membership_records(:one)
  end

  test "should get index" do
    get membership_records_url
    assert_response :success
  end

  test "should get new" do
    get new_membership_record_url
    assert_response :success
  end

  test "should create membership_record" do
    assert_difference('MembershipRecord.count') do
      post membership_records_url, params: { membership_record: { add_ons: @membership_record.add_ons, end_date: @membership_record.end_date, last_renewed: @membership_record.last_renewed, membership_id: @membership_record.membership_id, membership_level: @membership_record.membership_level, membership_level_type: @membership_record.membership_level_type, membership_scheme: @membership_record.membership_scheme, membership_status: @membership_record.membership_status, membership_term: @membership_record.membership_term, start_date: @membership_record.start_date } }
    end

    assert_redirected_to membership_record_url(MembershipRecord.last)
  end

  test "should show membership_record" do
    get membership_record_url(@membership_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_membership_record_url(@membership_record)
    assert_response :success
  end

  test "should update membership_record" do
    patch membership_record_url(@membership_record), params: { membership_record: { add_ons: @membership_record.add_ons, end_date: @membership_record.end_date, last_renewed: @membership_record.last_renewed, membership_id: @membership_record.membership_id, membership_level: @membership_record.membership_level, membership_level_type: @membership_record.membership_level_type, membership_scheme: @membership_record.membership_scheme, membership_status: @membership_record.membership_status, membership_term: @membership_record.membership_term, start_date: @membership_record.start_date } }
    assert_redirected_to membership_record_url(@membership_record)
  end

  test "should destroy membership_record" do
    assert_difference('MembershipRecord.count', -1) do
      delete membership_record_url(@membership_record)
    end

    assert_redirected_to membership_records_url
  end
end

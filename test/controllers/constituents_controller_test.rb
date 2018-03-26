require 'test_helper'

class ConstituentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @constituent = constituents(:one)
  end

  test "should get index" do
    get constituents_url
    assert_response :success
  end

  test "should get new" do
    get new_constituent_url
    assert_response :success
  end

  test "should create constituent" do
    assert_difference('Constituent.count') do
      post constituents_url, params: { constituent: { do_not_email: @constituent.do_not_email, dob: @constituent.dob, duplicate: @constituent.duplicate, email_id: @constituent.email_id, last_group: @constituent.last_group, lookup_id: @constituent.lookup_id, name: @constituent.name, phone: @constituent.phone, suffix: @constituent.suffix, title: @constituent.title } }
    end

    assert_redirected_to constituent_url(Constituent.last)
  end

  test "should show constituent" do
    get constituent_url(@constituent)
    assert_response :success
  end

  test "should get edit" do
    get edit_constituent_url(@constituent)
    assert_response :success
  end

  test "should update constituent" do
    patch constituent_url(@constituent), params: { constituent: { do_not_email: @constituent.do_not_email, dob: @constituent.dob, duplicate: @constituent.duplicate, email_id: @constituent.email_id, last_group: @constituent.last_group, lookup_id: @constituent.lookup_id, name: @constituent.name, phone: @constituent.phone, suffix: @constituent.suffix, title: @constituent.title } }
    assert_redirected_to constituent_url(@constituent)
  end

  test "should destroy constituent" do
    assert_difference('Constituent.count', -1) do
      delete constituent_url(@constituent)
    end

    assert_redirected_to constituents_url
  end
end

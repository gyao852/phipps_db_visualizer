require 'test_helper'

class ContactHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact_history = contact_histories(:one)
  end

  test "should get index" do
    get contact_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_contact_history_url
    assert_response :success
  end

  test "should create contact_history" do
    assert_difference('ContactHistory.count') do
      post contact_histories_url, params: { contact_history: { contact_history_id: @contact_history.contact_history_id, date: @contact_history.date, lookup_id: @contact_history.lookup_id, type: @contact_history.type } }
    end

    assert_redirected_to contact_history_url(ContactHistory.last)
  end

  test "should show contact_history" do
    get contact_history_url(@contact_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_contact_history_url(@contact_history)
    assert_response :success
  end

  test "should update contact_history" do
    patch contact_history_url(@contact_history), params: { contact_history: { contact_history_id: @contact_history.contact_history_id, date: @contact_history.date, lookup_id: @contact_history.lookup_id, type: @contact_history.type } }
    assert_redirected_to contact_history_url(@contact_history)
  end

  test "should destroy contact_history" do
    assert_difference('ContactHistory.count', -1) do
      delete contact_history_url(@contact_history)
    end

    assert_redirected_to contact_histories_url
  end
end

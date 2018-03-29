require 'test_helper'

class DonationHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @donation_history = donation_histories(:one)
  end

  test "should get index" do
    get donation_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_donation_history_url
    assert_response :success
  end

  test "should create donation_history" do
    assert_difference('DonationHistory.count') do
      post donation_histories_url, params: { donation_history: { amount: @donation_history.amount, date: @donation_history.date, do_not_acknowledge: @donation_history.do_not_acknowledge, donation_history_id: @donation_history.donation_history_id, given_anonymously: @donation_history.given_anonymously, lookup_id: @donation_history.lookup_id, method: @donation_history.method, transaction_type: @donation_history.transaction_type } }
    end

    assert_redirected_to donation_history_url(DonationHistory.last)
  end

  test "should show donation_history" do
    get donation_history_url(@donation_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_donation_history_url(@donation_history)
    assert_response :success
  end

  test "should update donation_history" do
    patch donation_history_url(@donation_history), params: { donation_history: { amount: @donation_history.amount, date: @donation_history.date, do_not_acknowledge: @donation_history.do_not_acknowledge, donation_history_id: @donation_history.donation_history_id, given_anonymously: @donation_history.given_anonymously, lookup_id: @donation_history.lookup_id, method: @donation_history.method, transaction_type: @donation_history.transaction_type } }
    assert_redirected_to donation_history_url(@donation_history)
  end

  test "should destroy donation_history" do
    assert_difference('DonationHistory.count', -1) do
      delete donation_history_url(@donation_history)
    end

    assert_redirected_to donation_histories_url
  end
end

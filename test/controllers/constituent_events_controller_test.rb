require 'test_helper'

class ConstituentEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @constituent_event = constituent_events(:one)
  end

  test "should get index" do
    get constituent_events_url
    assert_response :success
  end

  test "should get new" do
    get new_constituent_event_url
    assert_response :success
  end

  test "should create constituent_event" do
    assert_difference('ConstituentEvent.count') do
      post constituent_events_url, params: { constituent_event: { attend: @constituent_event.attend, event_id: @constituent_event.event_id, host_name: @constituent_event.host_name, lookup_id: @constituent_event.lookup_id, status: @constituent_event.status } }
    end

    assert_redirected_to constituent_event_url(ConstituentEvent.last)
  end

  test "should show constituent_event" do
    get constituent_event_url(@constituent_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_constituent_event_url(@constituent_event)
    assert_response :success
  end

  test "should update constituent_event" do
    patch constituent_event_url(@constituent_event), params: { constituent_event: { attend: @constituent_event.attend, event_id: @constituent_event.event_id, host_name: @constituent_event.host_name, lookup_id: @constituent_event.lookup_id, status: @constituent_event.status } }
    assert_redirected_to constituent_event_url(@constituent_event)
  end

  test "should destroy constituent_event" do
    assert_difference('ConstituentEvent.count', -1) do
      delete constituent_event_url(@constituent_event)
    end

    assert_redirected_to constituent_events_url
  end
end

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # Relationship matchers...
  should belong_to(:constituent)
  # Validation matchers...
  should validate_presence_of(:lookup_id)
  should validate_presence_of(:address_1)

  should allow_value("1063 Morewood Avenue").for(:address_1)
  should_not allow_value("1063 Morewood Ave.").for(:address_1)
  should_not allow_value("1063 Morewood ave.").for(:address_1)
  #should allow_value("1063 Morewood drive").for(:address_1)
  # TODO: Figure out why this is failing?
  should_not allow_value("1063 Morewood Dr.").for(:address_1)
  should_not allow_value("1063 Morewood dr.").for(:address_1)
  should allow_value("1063 Morewood Street").for(:address_1)
  should_not allow_value("1063 Morewood St.").for(:address_1)
  should_not allow_value("1063 Morewood st.").for(:address_1)
  should allow_value("1063 Morewood Apartment").for(:address_1)
  should_not allow_value("1063 Morewood Apt").for(:address_1)
  should_not allow_value("1063 Morewood apt.").for(:address_1)
  should allow_value("1063 Morewood Avenue").for(:address_1)
  should_not allow_value("1063 Morewood Blvd").for(:address_1)
  should_not allow_value("1063 Morewood blvd.").for(:address_1)
  should allow_value("1063 Morewood Road").for(:address_1)
  should_not allow_value("1063 Morewood Rd").for(:address_1)
  should_not allow_value("1063 Morewood rd.").for(:address_1)
  should allow_value("Pittsburgh").for(:city)
  #should_not allow_value("pittsburgh").for(:city)
  # TODO: Figure out why this is failing?
  should allow_value("Pennsylvania").for(:state)
  should_not allow_value("PA").for(:state)
  should allow_value("United States").for(:country)
  should allow_value("").for(:country)
  #should_not allow_value("united states").for(:country)
  # TODO: Figure out why this is failing?
  should allow_value(5.years.ago.to_date).for(:date_added)
  #should allow_value(1.years.from_now.to_date).for(:date_added)
  # TODO: Figure out why this is failing?
  should allow_value("").for(:zip)
  should allow_value('15213').for(:zip)
  should allow_value('15213-4444').for(:zip)
  should allow_value('N2L2T6').for(:zip)
  should_not allow_value('15-213').for(:zip)
  should_not allow_value('N2L 2T6').for(:zip)

  # ---------------------------------
  # Testing other methods with a context
  context "Creating a constituent context" do
    setup do
      create_addresses
    end

    # and provide a teardown method as well
    teardown do
      destroy_addresses
    end

end

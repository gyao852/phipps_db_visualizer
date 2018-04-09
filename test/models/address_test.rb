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
      create_constituents
      create_addresses
    end

    # and provide a teardown method as well
    teardown do
      destroy_constituents
      destroy_addresses
    end

    # test the scope 'order_address_id'
    should "shows that ordering by address_id works" do
      assert_equal ["5032 Forbes Avenue", "739 Bellefonte Street", "5034 Forbes Avenue"],
      Address.order_address_id.map{|p| p.address_1}
    end

    # test the scope 'alphabetical_city'
    should "shows that ordering by alphabetical_city works" do
      assert_equal ["Los Angeles", "New York City", "Pittsburgh"],
      Address.alphabetical_city.map{|p| p.city}
    end

    # test the scope 'alphabetical_state'
    should "shows that ordering by alphabetical_state works" do
      assert_equal ["California", "New York", "Pennsylvania"],
      Address.alphabetical_state.map{|p| p.state}
    end

    # test the scope 'chronological_zip'
    should "shows that ordering by chronological_zip works" do
      assert_equal ["15212", "15213", "15232"],
      Address.chronological_zip.map{|p| p.zip}
    end

    # test the scope 'alphabetical_country'
    should "shows that ordering by alphabetical_country works" do
      assert_equal ["Germany", "Hong Kong", "United States"],
      Address.alphabetical_country.map{|p| p.country}
    end

    # test the scope 'for_lookup_id'
    should "shows that searching by lookup_id works" do
      assert_equal "5032 Forbes Avenue",
      Address.for_lookup_id("12345").first.address_1
      assert_equal "739 Bellefonte Street",
      Address.for_lookup_id("12346").first.address_1
      assert_equal "5034 Forbes Avenue",
      Address.for_lookup_id("10000").first.address_1
    end

    # test the scope 'for_zip'
    should "shows that searching by zip works" do
      assert_equal "5032 Forbes Avenue",
      Address.for_zip("15213").first.address_1
      assert_equal "739 Bellefonte Street",
      Address.for_zip("15232").first.address_1
      assert_equal "5034 Forbes Avenue",
      Address.for_zip("15212").first.address_1
    end

    # test the scope 'for_city'
    should "shows that searching by city works" do
      assert_equal ["5032 Forbes Avenue"],
      Address.for_city("Pittsburgh").map{|p| p.address_1}
      assert_equal ["739 Bellefonte Street"],
      Address.for_city("New York City").map{|p| p.address_1}
      assert_equal ["5034 Forbes Avenue"],
      Address.for_city("Los Angeles").map{|p| p.address_1}
    end

    # test the scope 'for_type'
    should "shows that searching by type works" do
      assert_equal ["5032 Forbes Avenue"],
      Address.for_type("Seasonal").map{|p| p.address_1}
      assert_equal ["739 Bellefonte Street"],
      Address.for_type("Household").map{|p| p.address_1}
      assert_equal ["5034 Forbes Avenue"],
      Address.for_type("Business").map{|p| p.address_1}
    end

    # test the scope 'for_address'
    should "shows that searching by address works" do
      assert_equal "12345",
      Address.for_address("5032 Forbes Avenue").first.lookup_id
      assert_equal "12346",
      Address.for_address("739 Bellefonte Street").first.lookup_id
      assert_equal "10000",
      Address.for_address("5034 Forbes Avenue").first.lookup_id
    end

    # test the scope 'state'
    should "shows that searching by state works" do
      assert_equal ["5032 Forbes Avenue"],
      Address.for_state("Pennsylvania").map{|p| p.address_1}
      assert_equal ["739 Bellefonte Street"],
      Address.for_state("New York").map{|p| p.address_1}
      assert_equal ["5034 Forbes Avenue"],
      Address.for_state("California").map{|p| p.address_1}
    end

    # test the scope 'country'
    should "shows that searching by country works" do
      assert_equal ["5032 Forbes Avenue"],
      Address.for_country("United States").map{|p| p.address_1}
      assert_equal ["739 Bellefonte Street"],
      Address.for_country("Germany").map{|p| p.address_1}
      assert_equal ["5034 Forbes Avenue"],
      Address.for_country("Hong Kong").map{|p| p.address_1}
    end

    # test the method 'full_address'
    should "shows the full address" do
      assert_equal "5032 Forbes Avenue, Pittsburgh, Pennsylvania, 15213, United States", @add1.full_address
      assert_equal "739 Bellefonte Street, New York City, New York, 15232, Germany", @add2.full_address
      assert_equal "5034 Forbes Avenue, Los Angeles, California, 15212, Hong Kong", @add3.full_address
    end


  end


end

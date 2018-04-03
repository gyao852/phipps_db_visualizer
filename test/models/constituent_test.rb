require 'test_helper'

class ConstituentTest < ActiveSupport::TestCase
  # Relationship matchers...
    should have_many(:addresses)
    should have_many(:donation_histories)
    have_many(:donation_programs).through(:donation_histories)
    should have_many(:constituent_events)
    have_many(:events).through(:constituent_events)
    should have_many(:contact_histories)
    should have_many(:constituent_membership_records)
    have_many(:membership_records).through(:constituent_membership_records)

  # Validation matchers...
    should validate_presence_of(:lookup_id)
    should validate_presence_of(:last_group)
    #TODO: Finish up validation tests; but check first validations are incorrect

  # ---------------------------------
  # Testing other methods with a context
  context "Given context" do
    setup do
      @bruce = FactoryGirl.create(:constituent)
      @yaoFam = FactoryGirl.create(:constituent, lookup_id: "12346",
        name: "Yao Family", last_group: "Yao Family",
        email_id: "GeorgeY852@gmail.com", phone: "(412)-324-4231",
        do_not_email: true, duplicate: false, constituent_type: )
      @pnc = FactoryGirl.create(:constituent, lookup_id: "10000",
        name: "PNC", last_group: "PNC",
        email_id: "qwer@pnc.com", phone: "(888)-444-3333",
        do_not_email: false, duplicate: false, constituent_type: "Organization")
    end

    # and provide a teardown method as well
    teardown do
      @bruce.destroy
      @yaoFam.destory
      @pnc.destory
    end

    should "show that constituent record is created properly" do
      assert_equal "12345", @bruce.lookup_id
      assert_equal "Mr.", @bruce.title
      assert_equal "Bruce Wayne", @bruce.name
      assert_equal "Wayne", @bruce.last_group
      assert_equal "abc@mail.com", @bruce.email_id
      assert_equal "(123)-456-7890", @bruce.phone
      assert_equal 20.years.ago, @bruce.dob
      assert_equal false, @bruce.do_not_email
      assert_equal false, @bruce.duplicate
      assert_equal "Individual", @bruce.constituent_type
      assert_equal "Ask for batman", @bruce.phone_notes
    end

    # test the scope 'by_lookup_id'
    should "shows that ordering by lookup id works" do
      assert_equal 3, Constituent.all.size # quick check of size
      assert_equal ["10000", "12346", "12345"],
      Constituent.by_lookup_id.map{|p| p.lookup_id}
    end

    # test the scope 'alphabetical_last_group'
    should "shows that ordering by last_group works" do
      assert_equal ["PNC", "Yao Family", "Wayne"],
      Constituent.alphabetical_last_group.map{|p| p.last_group}
    end

    # test the scope 'alphabetical_name'
    should "shows that ordering by name works" do
      assert_equal ["Bruce Wayne","PNC", "Yao Family"],
      Constituent.alphabetical_name.map{|p| p.name}
    end

    # test the scope 'individual'
    should "shows that search for individual works" do
      assert_equal ["Bruce Wayne"], Constituent.inidividaul.map{|p| p.name}

    # test the scope 'household'
    should "shows that search for individual works" do
      assert_equal ["Yao Family"], Constituent.household.map{|p| p.name}
    end

    # test the scope 'company'
    should "shows that search for company works" do
      assert_equal ["PNC"], Constituent.company.map{|p| p.name}
    end

end

module Contexts
  def create_constituents
    @bruce = FactoryBot.create(:constituent)
    @yaoFam = FactoryBot.create(:constituent, lookup_id: "12346",
      name: "Yao Family", last_group: "Yao Family",
      email_id: "GeorgeY852@gmail.com", phone: "(412)-324-4231",
      do_not_email: true, duplicate: false, constituent_type:"Household")
    @pnc = FactoryBot.create(:constituent, lookup_id: "10000",
      name: "PNC", last_group: "PNC",email_id: "qwer@pnc.com",
      phone: "(888)-444-3333",do_not_email: false, duplicate: false,
      constituent_type: "Organization")
  end

  def destroy_constituents
    @bruce.destroy
    @yaoFam.destroy
    @pnc.destroy
  end

  def create_addresses
    @add1 = FactoryBot.create(:address)
    @add2 = FactoryBot.create(:address, lookup_id: "12346",
      address_1: "739 Bellefonte Street", city: "New York City",
      state: "New York", zip: "15232", country: "Germany",
      address_type: "Household", date_added: 4.months.ago.to_date)
    @add3 = FactoryBot.create(:address, lookup_id: "10000",
      address_1: "5034 Forbes Avenue", city: "Los Angeles",
      state: "California", zip: "15212", country: "Hong Kong",
      address_type: "Business", date_added: 2.months.ago.to_date)
  end

  def destroy_addresses
    @add1.destroy
    @add2.destroy
    @add3.destroy
  end

  def create_constituent_membership
    @mc1 = FactoryBot.create(:constituent_membership_record)
    @mc2 = FactoryBot.create(:constituent_membership_record, lookup_id: "12346",
            membership_id: "800-100001")
  end

  def destroy_constituent_membership
    @mc1.destroy
    @mc2.destroy
  end

  def create_membership_records
    @mem1 = FactoryBot.create(:membership_record)
    @mem2 = FactoryBot.create(:membership_record, membership_id: "800-100001",
    membership_scheme: "Green Mountain Membership",
    membership_level: "Student/Senior",add_ons: "",
    membership_level_type:"Patron", membership_status: "Non-active",
    membership_term: 1, start_date: 2.year.ago.to_date,
    end_date: 1.year.ago.to_date, last_renewed:nil)
    # No membership for PNC; this is to test to see if constituent_type
    # function current_membership_level/scheme returns nil correctly
  end
  def destroy_membership_records
    @mem1.destroy
    @mem2.destroy
  end

end

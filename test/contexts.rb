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
      address_1: "739 Bellefonte St", city: "Pittsburgh",
      state: "Pennsylvania", zip: "15232", address_type "Home",
      date_added: 4.months.ago.to_date)
    @add3 = FactoryBot.create(:address, lookup_id: "10000",
      address_1: "5034 Forbes Ave", city: "Pittsburgh",
      state: "Pennsylvania", zip: "15213", address_type "Business",
      date_added: 2.months.ago.to_date)
  end

  def destroy_addresses
    @add1.destroy
    @add2.destroy
    @add3.destroy
  end

end

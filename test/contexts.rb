module Contexts
  def create_constituents
    @bruce = FactoryBot.create(:constituent)
    @yaoFam = FactoryBot.create(:constituent, lookup_id: "12346", name: "Yao Family", last_group: "Yao Family", email_id: "GeorgeY852@gmail.com", phone: "(412)-324-4231", do_not_email: true, duplicate: false, constituent_type:"Household")
    @pnc = FactoryBot.create(:constituent, lookup_id: "10000",
      name: "PNC", last_group: "PNC",email_id: "qwer@pnc.com", phone: "(888)-444-3333",do_not_email: false, duplicate: false, constituent_type: "Organization")
  end

  def destroy_constituents
    @bruce.destroy
    @yaoFam.destory
    @pnc.destory
  end

end

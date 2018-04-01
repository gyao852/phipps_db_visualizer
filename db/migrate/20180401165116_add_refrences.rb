class AddRefrences < ActiveRecord::Migration[5.1]
  def change
    add_reference :Addresses, :Constituents
    add_reference :constituent_membership_records, :Constituents
    add_reference :contact_histories, :constituents
    add_reference :constituent_events, :constituents
    add_reference :donation_histories, :constituents
    add_reference :donation_histories, :donationprograms
    add_reference :constituent_events, :events
    add_reference :constituent_membership_records, :memberhsip_records
  end
end

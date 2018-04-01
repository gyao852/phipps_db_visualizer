FactoryBot.define do
    factory :constituent do
        lookup_id "12345"
        suffix "Mr."
        name "Bruce"
        last_group "Wayne"
        email_id "abc@mail.com"
        phone "(123)-456-7890"
        dob 20.year.ago.to_date
        do_not_email false
        duplicate false
        constituent_type "Individual"
        phone_notes "Ask for batman"

    end

    factory :constituent_membership_record do
      membership_id "l33t h4x0r"
      lookup_id "12345"
      Constituents_id "12345"
    end

    factory :membership_record do
      membership_id "l33t h4x0r"
      membership_scheme "Phipps General Membership"
      membership_level "Student/Senior"
      add_ons ""
      membership_level_type "Patron"
      membership_status "Active"
      membership_term "1 Year"
      start_date 10.year.ago.to_date
      end_date 1.year.from_now
      last_renewed Date.today
    end

    factory :address do
        association :constituent
        lookup_id "12345"
        address_1 "5032 Forbes Avenue"
        city "Pittsburgh"
        state "PA"
        zip "15213"
        country "USA"
        address_type "Household"
        date_added Date.today
    end

    factory :donation_program do
        program 'Green Initiative'
        active 'true'
    end

    factory :donation_history do
        association :constituent
        association :donation_program
        amount 50
        date 3.months.ago.to_date
        do_not_acknowledge false
        given_anonymously false
        transaction_type 'iono'
    end


end

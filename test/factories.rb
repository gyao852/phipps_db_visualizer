FactoryBot.define do

    factory :address do
        association :constituent
        lookup_id "12345"
        address_1 "5032 Forbes Avenue"
        city "Pittsburgh"
        state "PA"
        zip "15213"
        country "USA"
        address_type "Household"
        date_added 1.year.ago.to_date
    end

    factory :constituent_event do
      association :event
      association :constituent
      lookup_id "12345"
      status "Registered"
      attend "Yes"
      host_name "Bruce Wayne"
      event_id "1"
      # TODO: Ask ash why we need constituent_id in schema.rb
    end

    factory :constituent_membership_record do
      association :constituent
      association :membership_records
      lookup_id "12345"
      membership_id "l33t h4x0r"
      # TODO: Again, ask Ash about Constituents_id??
      constituents_id "12345"
    end

    factory :constituent do
        lookup_id "12345"
        suffix ""
        title "Mr."
        name "Bruce Wayne"
        last_group "Wayne"
        email_id "abc@mail.com"
        phone "(123)-456-7890"
        dob 20.years.ago.to_date
        do_not_email false
        duplicate false
        constituent_type "Individual"
        phone_notes "Ask for batman"
    end

    factory :contact_history do
      association :constituent
      #contact_history_id ""
      lookup_id "12345"
      type "email"
      date 2.months.ago.to_date
    end

    factory :donation_history do
        association :constituent
        association :donation_program
        donation_history_id '15213'
        amount 500
        date 3.months.ago.to_date
        do_not_acknowledge false
        given_anonymously false
        transaction_type 'donation'
        payment_method 'cash'

    end

    factory :donation_program do
        program 'Green Initiative'
        active 'true'
    end

    factory :event do
      event_id "1"
      event_name "Member's Only Night"
      category "Members"
      start_date_time Time.zone.local(2018,2,3,11)
      end_date_time Time.zone.local(2018,2,3,17)
    end

    factory :membership_record do
      membership_id "l33t h4x0r"
      membership_scheme "Phipps General Membership"
      membership_level "Student/Senior"
      add_ons ""
      membership_level_type "Patron"
      membership_status "Active"
      membership_term "1 Year"
      start_date 3.years.ago.to_date
      end_date 1.year.from_now
      last_renewed Date.today
    end

    factory :user do
      user_id "1"
      fname "George"
      lname "Yao"
      email_id "gyao@andrew.cmu.edu"
      password_digest "12345"
      active true
    end
end

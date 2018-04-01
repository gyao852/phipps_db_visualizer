FactoryBot.define do
    factory :constituent do
        lookup_id "12345"
        name "John"
        last_group "Smith"
        phone "(123)-456-7890"
        email_id "abc@mail.com"
        dob 20.year.ago.to_date
        do_not_email false

    end

    factory :address do
        association :constituent
        address_1 "5032 Forbes Avenue"
        city "Pittsburgh"
        state "PA"
        zip "15213"
        country "USA"
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
FactoryBot.define do
    factory :constituent do
        lookup_id "12345"
        name "John"
        last_group "Smith"
        phone "(123) 456-7890"
    end

    factory :address do
        association :constituent
        address_1 "5032 Forbes Avenue"
        city "Pittsburgh"
        state "PA"
        zip "15213"
        country "USA"
    end


end
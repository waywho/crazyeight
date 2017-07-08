FactoryGirl.define do
  factory :game do
    association :user
    name "MyString"
  end
end

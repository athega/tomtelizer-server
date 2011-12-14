FactoryGirl.define do
  factory :image do
    sequence :filename do |n|
      "filename-#{n}.jpg"
    end
    sequence :hatified_file_checksum do |n|
      "checksum#{n}"
    end
    width              600
    height             400
    hatified_file_size 40000
    orientation        6
  end
end


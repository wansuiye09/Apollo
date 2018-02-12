FactoryBot.define do
  factory :base_schema_version, class: 'Base::SchemaVersion' do
    version_number 1
    schema_ref 'draft6'
    schema {}
    example {}
  end
end

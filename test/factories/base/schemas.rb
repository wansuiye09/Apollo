FactoryBot.define do
  factory :base_schema, class: 'Base::Schema' do
    schema_ref 'draft6'
    schema {{
      'type'=>'object',
      'required' => ['a'],
      'properties' => {
        'a' => {
          'type' => 'integer',
          'default' => 42
        },
        'b' => {
          'type' => 'object',
          'properties' => {
            'x' => {
              'type' => 'integer'
            }
          }
        }
      }
    }}
    example {{ 'a' => 1 }}
  end
end

require 'spec_helper'

describe Role do
  it 'should create an admin role' do
    role = create(:admin_role)
    role.name.should eq 'admin'
  end
end

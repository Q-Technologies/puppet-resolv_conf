require 'spec_helper'
describe 'resolv_conf' do
  context 'with default values for all parameters' do
    it { should contain_class('resolv_conf') }
  end
end

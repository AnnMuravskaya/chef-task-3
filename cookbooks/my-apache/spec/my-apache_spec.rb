require 'spec_helper'
require 'chef-vault'

describe 'my-apache::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'apache::template' do
    expect(chef_run).to create_template('/var/www/html/index.html')
  end

  it 'create::users' do
    expect(chef_run).to create_user('user1')
  end

  it 'update:apt_repo' do
    expect(chef_run).to update_apt_update('repo')
  end

  it 'install::apache2' do
    expect(chef_run).to install_apt_package('apache2')
  end
end

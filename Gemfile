source  'https://rubygems.org'

# get this from git for the chefignore issues
gem 'berkshelf'

group 'develop' do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  # can remove and goto upstream when:
  # https://github.com/test-kitchen/kitchen-openstack/pull/40 merged
  gem 'kitchen-openstack',
      git: 'https://github.com/wilreichert/kitchen-openstack.git',
      branch: 'user_data'
  gem 'rake'
  # https://github.com/acrmp/foodcritic/pull/190
  # and fixes the nokogiri conflict
  gem 'foodcritic',
      git: 'https://github.com/spheromak/foodcritic.git',
      branch: 'works_with_openstack'
  gem 'rubocop'
  gem 'knife-cookbook-doc'
  gem 'chefspec', '>= 3.2.0'
  gem 'git'
end

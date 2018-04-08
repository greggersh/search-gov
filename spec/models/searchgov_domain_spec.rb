#FIXME: require 'rails_helper'
#git mv spec/spec_helper.rb spec/rails_helper.rb
#https://relishapp.com/rspec/rspec-rails/docs/upgrade
require 'spec_helper'

RSpec.describe SearchgovDomain, type: :model do
  describe 'schema' do
    it do
      is_expected.to have_db_column(:domain).of_type(:string).
        with_options(null: false)
    end
    it do
      is_expected.to have_db_column(:clean_urls).of_type(:boolean).
        with_options(default: true, null: false)
    end
    it do
      is_expected.to have_db_column(:status).of_type(:integer).
        with_options(null: false)
    end
    it { is_expected.to have_db_index(:domain) }#.unique(true)
  end

  describe 'associations' do
    it { is_expected.to have_many(:searchgov_urls).dependent(:destroy) }
  end

  #readonly
end

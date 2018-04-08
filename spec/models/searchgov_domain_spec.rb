require 'rails_helper'

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
    it { is_expected.to have_db_index(:domain).unique(true) }
  end

  #readonly
end

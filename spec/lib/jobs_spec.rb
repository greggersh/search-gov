require 'spec_helper'

describe Jobs do
  describe '.search(options)' do
    context "when there is some problem" do
      before do
        allow(Rails.application.secrets).to receive(:jobs).and_return({
          'host' => 'http://nonexistent.server.gov',
          'endpoint' => '/test/search',
          'adapter' => Faraday.default_adapter
        })
        Jobs.establish_connection!
      end

      it "should log any errors that occur and return nil" do
        expect(Rails.logger).to receive(:error).with(/Trouble fetching jobs information/)
        expect(Jobs.search(:query => 'jobs')).to be_nil
      end
    end
  end

  describe '.query_eligible?(query)' do
    context "when the search phrase contains hyphenated words" do
      it 'should return true' do
        expect(Jobs.query_eligible?('full-time jobs')).to be true
        expect(Jobs.query_eligible?('intern')).to be true
        expect(Jobs.query_eligible?('seasonal')).to be true
      end
    end

    context 'when the search phrase is blocked' do
      it 'should return false' do
        ["employment data", "employment statistics", "employment numbers", "employment levels", "employment rate",
         "employment trends", "employment growth", "employment projections", "employment #{Date.current.year.to_s}",
         "employment survey", "employment forecasts", "employment figures", "employment report", "employment law",
         "employment at will", "equal employment opportunity", "employment verification", "employment status",
         "employment record", "employment history", "employment eligibility", "employment authorization", "employment card",
         "job classification", "job analysis", "posting 300 log", "employment forms", "job hazard", "job safety",
         "job poster", "job training", "employment training", "job fair", "job board", "job outlook", "grant opportunities",
         "funding opportunities", "vacancy factor", "vacancy rates", "delayed opening", "opening others mail", "job corps cuts",
         "job application", "job safety and health poster", "job safety analysis standard", "job safety analysis", "employment contract",
         "application for employment"
        ].each { |phrase| expect(Jobs.query_eligible?(phrase)).to be false }
      end
    end

    context 'when the search phrase has advanced query characteristics' do
      it 'should return false' do
        ['job "city of farmington"',
         'job -loren',
         'job (assistant OR parks)',
         'job filetype:pdf',
         '-loren job'
        ].each { |phrase| expect(Jobs.query_eligible?(phrase)).to be false }
      end
    end
  end
end

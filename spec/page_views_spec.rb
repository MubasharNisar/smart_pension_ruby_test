# frozen_string_literal: true

require_relative '../lib/page_views'

RSpec.describe PageViews, type: :model do # rubocop:disable Metrics/BlockLength
  subject { described_class.new(file_path) }
  let(:file_path) { 'spec/sample.log' }

  describe 'process' do
    context 'process with incorrect file' do
      let(:file_path) { 'test.log' }

      it 'should raise not a file or directory error' do
        expect { subject.process }.to raise_error(RuntimeError, "No such file or directory '#{file_path}'")
      end
    end

    context 'process with correct file' do
      before { subject.process }

      let(:expected_result) do
        {
          '/help_page/1' => ['126.318.035.038', '929.398.951.889'],
          '/contact' => ['184.123.665.067'],
          '/about' => ['061.945.150.735'],
          '/about/2' => ['444.701.448.104', '444.701.448.104'],
          '/home' => ['184.123.665.067'],
          '/index' => ['444.701.448.104']
        }
      end

      it 'returns parsed data hash' do
        expect(subject.data_hash).to eq(expected_result)
      end
    end
  end

  describe 'most_visits' do
    before { subject.process }
    let(:expected_result) do
      {
        '/help_page/1' => 2,
        '/about/2' => 2,
        '/contact' => 1,
        '/about' => 1,
        '/home' => 1,
        '/index' => 1
      }
    end

    it 'returns sorted count of each page visit' do
      expect(subject.most_visits).to eq(expected_result)
    end
  end

  describe 'unique_visits' do
    before { subject.process }
    let(:expected_result) do
      {
        '/help_page/1' => 2,
        '/about/2' => 1,
        '/contact' => 1,
        '/about' => 1,
        '/home' => 1,
        '/index' => 1
      }
    end

    it 'returns sorted count of each page unique visit' do
      expect(subject.unique_visits).to eq(expected_result)
    end
  end
end

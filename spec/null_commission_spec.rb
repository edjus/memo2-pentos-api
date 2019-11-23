require 'spec_helper'

describe NullCommission do
  subject(:commision) { described_class.new }

  describe 'model' do
    it { is_expected.to respond_to(:amount) }
    it { is_expected.to respond_to(:weather) }
    it { is_expected.to respond_to(:id) }
  end

  describe 'amount' do
    it 'should raise an OrderNotDeliveredError' do
      expect { commision.amount }.to raise_error(OrderNotDeliveredError)
    end
  end

  describe 'weather' do
    it 'should return NonRainyWeather as default' do
      weather = commision.weather

      expect(weather).to be_a(NonRainyWeather)
    end
  end

  describe 'id' do
    it 'should return -1' do
      id = commision.id

      expect(id).to eq(-1)
    end
  end
end

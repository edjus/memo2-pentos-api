require 'spec_helper'
require_relative '../app/model/delivery_assigner'
require_relative '../app/repositories/order_repository.rb'
require_relative '../app/repositories/client_repository.rb'
require_relative '../app/model/order'
require_relative '../app/model/client'

describe DeliveryAssigner do
  let(:order) { Order.new(client: client, type: 'menu_individual') }
  let(:client) do
    Client.new('username' => 'jperez', 'phone' => '4123-4123',
               'address' => 'Av Paseo Colón 840')
  end
  let(:client_repository) { ClientRepository.new }
  let(:orders_repository) { OrderRepository.new }
  let(:repository) { DeliveryRepository.new }
  let(:sorting_hat) { described_class.new }
  let(:weather) { NonRainyWeather.new }

  describe 'model' do
    it { is_expected.to respond_to(:filter) }
  end

  it 'should return a delivery I save' do
    delivery = Delivery.new('username' => 'pepemoto')
    repository.save(delivery)
    sorting_hat.assign_to(order)

    expect(order.assigned_to).to eq(delivery.username)
  end

  it 'given an order, delivery assigner should assign it a delivery' do
    delivery = Delivery.new('username' => 'pepemoto')
    repository.save(delivery)
    sorting_hat.assign_to(order)
    expect(order.assigned_to).not_to eq(nil)
  end
  # rubocop:disable RSpect/ExampleLength

  it 'should assign the delivery with less delivered orders' do
    delivery = Delivery.new('username' => 'pepemoto')
    delivery2 = Delivery.new('username' => 'pepeauto')
    order = Order.new(client: client, type: 'menu_individual',
                      assigned_to: delivery.username)
    order.state = DeliveredState.new

    client_repository.save(client)
    repository.save(delivery)
    repository.save(delivery2)
    orders_repository.save(order)

    sorting_hat.assign_to(order)
    expect(order.assigned_to).to eq(delivery2.username)
  end

  it 'given an order, delivery assigner should assign the nearest to fill its bag' do
    client_repository.save(client)

    delivery = Delivery.new('username' => 'pepemoto')
    delivery2 = Delivery.new('username' => 'pepeauto')

    repository.save(delivery)
    repository.save(delivery2)

    order.change_state(OnDeliveryState.new(weather))

    orders_repository.save(order)
    new_order = Order.new(client: client, type: 'menu_familiar')

    sorting_hat.assign_to(new_order)
    expect(new_order.assigned_to).not_to eq(order.assigned_to)
  end
  # rubocop:enable RSpect/ExampleLength
end

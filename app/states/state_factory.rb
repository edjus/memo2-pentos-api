require_relative '../states/recieved_state'
require_relative '../states/inpreparation_state'
require_relative '../states/ondelivery_state'
require_relative '../states/delivered_state'
require_relative '../states/invalid_state'

class StateFactory
  STATE_CREATOR = { 'recibido' => proc { |_weather| RecievedState.new },
                    'en_preparacion' => proc { |_weather| InPreparationState.new },
                    'en_entrega' => proc { |_weather| OnDeliveryState.new },
                    'entregado' => proc { |weather| DeliveredState.new(weather) },
                    'invalid_state' => proc { |_weather| InvalidState.new },
                    'cancelado' => proc { |_weather| CancelledState.new } }.freeze

  def initialize(weather)
    @weather = weather
  end

  def create_for(state_name)
    return InvalidState.new unless STATE_CREATOR.include?(state_name)

    STATE_CREATOR[state_name].call(@weather)
  end
end
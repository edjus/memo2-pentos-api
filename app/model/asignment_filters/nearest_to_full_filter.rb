require_relative 'delivered_count_filter'
require_relative 'filter'

class NearestToFullFilter < Filter
  def initialize
    @next_filter = DeliveredCountFilter.new
  end

  def apply(deliveries, _order)
    deliveries.group_by { |delivery| delivery.bag.size }.min.last
  end
end
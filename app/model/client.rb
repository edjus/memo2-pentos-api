class Client
  attr_accessor :id, :name, :phone, :address, :updated_on, :created_on

  VALID_NAME_REGEX = /\A[_A-z0-9]*((-)*[_A-z0-9])*\Z/.freeze
  VALID_PHONE_REGEX = /\A(\d)+-?(\d)+\Z/.freeze

  MIN_ADDRESS_LENGTH = 5

  # rubocop:disable Metrics/AbcSize
  def initialize(data = {})
    @id = data[:id]

    raise InvalidParameterError, ERRORS::INVALID_USERNAME unless valid_username?(data[:username])

    @name = data[:username]

    raise InvalidParameterError, ERRORS::INVALID_PHONE unless valid_phone?(data[:phone])

    @phone = data[:phone]

    raise InvalidParameterError, ERRORS::INVALID_ADDRESS unless valid_address?(data[:address])

    @address = data[:address]
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
  end
  # rubocop:enable Metrics/AbcSize

  def username?(username)
    @name == username
  end

  private

  def valid_username?(username)
    !username.blank? && VALID_NAME_REGEX.match?(username)
  end

  def valid_phone?(phone)
    !phone.blank? && VALID_PHONE_REGEX.match?(phone)
  end

  def valid_address?(address)
    !address.blank? && address.size >= MIN_ADDRESS_LENGTH
  end
end

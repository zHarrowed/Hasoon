# frozen_string_literal: true

class ParsingError::AddressError < StandardError
  attr_reader :address_string

  def initialize(address_string: nil)
    @address_string = address_string
    super
  end

  def message
    return "Could not parse address: '#{address_string}'"

    super
  end
end

# frozen_string_literal: true

class ParseAddressService
  attr_reader :address_string

  def initialize(address_string)
    @address_string = address_string.strip
  end

  def call
    address_hashes = []
    case address_string
    when /^\D+\s\d+$/
      street_name, _, street_number = address_string.rpartition(' ')
      address_hashes << { street_name: street_name, street_number: street_number }
    when /^\D+\s\d+[a-z]$/
      street_name, _, street_number = address_string.rpartition(' ')
      address_hashes << { street_name: street_name, street_number: street_number }
    when /^\D+\s\d+\s[a-z]$/
      *street_name_array, street_number, street_number_letter = address_string.split(' ')
      street_name = street_name_array.join(' ')
      address_hashes << { street_name: street_name,
                          street_number: "#{street_number}#{street_number_letter}" }
    when /^\D+\s\d+\s[A-Z]$/
      *street_name_array, street_number, building_letter = address_string.split(' ')
      street_name = street_name_array.join(' ')
      address_hashes << { street_name: street_name,
                          street_number: "#{street_number} #{building_letter}" }
    when /^\D+\s\d+\s-\s\d+$/
      *street_name_array, street_number_1, _, street_number_2 = address_string.split(' ')
      street_name = street_name_array.join(' ')
      address_hashes << { street_name: street_name,
                          street_number: "#{street_number_1} - #{street_number_2}" }
    when /^\D+\s\d+-\d+$/
      street_name, _, street_number_string = address_string.rpartition(' ')
      street_number_1, street_number_2 = street_number_string.split('-')
      address_hashes << { street_name: street_name,
                          street_number: "#{street_number_1} - #{street_number_2}" }
    when /^\D+\s(\d+,\s)*\d+\sja\s\d+$/
      address_numbers = []
      address_string_remainder, address_number = address_string.split(' ja ')
      address_numbers << address_number
      address_string_remainder, *address_number_additions = address_string_remainder.split(', ')
      address_numbers += address_number_additions
      street_name, _, street_number = address_string_remainder.rpartition(' ')
      address_numbers << street_number
      address_numbers.each do |address_number|
        address_hashes << { street_name: street_name, street_number: address_number }
      end
    else
      raise ParsingError::AddressError.new(address_string: address_string)
    end
    address_hashes
  end
end

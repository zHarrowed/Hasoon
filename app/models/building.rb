# frozen_string_literal: true

class Building < ApplicationRecord
  has_many :addresses, dependent: :destroy, autosave: true

  def addresses=(addresses_array)
    address_objects = []
    addresses_array.each do |address_string|
      address_string = address_string.strip
      case address_string
      when /^\D+\s\d+$/
        street_name, _, street_number = address_string.rpartition(' ')
        address_objects << Address.find_or_initialize_by(street_name: street_name, street_number: street_number)
      when /^\D+\s\d+[a-z]$/
        street_name, _, street_number = address_string.rpartition(' ')
        address_objects << Address.find_or_initialize_by(street_name: street_name, street_number: street_number)
      when /^\D+\s\d+\s[a-z]$/
        *street_name_array, street_number, street_number_letter = address_string.split(' ')
        street_name = street_name_array.join(' ')
        address_objects << Address.find_or_initialize_by(street_name: street_name,
                                                         street_number: "#{street_number}#{street_number_letter}")
      when /^\D+\s\d+\s[A-Z]$/
        *street_name_array, street_number, building_letter = address_string.split(' ')
        street_name = street_name_array.join(' ')
        address_objects << Address.find_or_initialize_by(street_name: street_name,
                                                         street_number: "#{street_number} #{building_letter}")
      when /^\D+\s\d+\s-\s\d+$/
        *street_name_array, street_number_1, _, street_number_2 = address_string.split(' ')
        street_name = street_name_array.join(' ')
        address_objects << Address.find_or_initialize_by(street_name: street_name,
                                                         street_number: "#{street_number_1} - #{street_number_2}")
      when /^\D+\s\d+-\d+$/
        street_name, _, street_number_string = address_string.rpartition(' ')
        street_number_1, street_number_2 = street_number_string.split('-')
        address_objects << Address.find_or_initialize_by(street_name: street_name,
                                                         street_number: "#{street_number_1} - #{street_number_2}")
      when /^\D+\s(\d+,\s)*\d+\sja\s\d+$/
        address_numbers = []
        address_string_remainder, address_number = address_string.split(' ja ')
        address_numbers << address_number
        address_string_remainder, *address_number_additions = address_string_remainder.split(', ')
        address_numbers += address_number_additions
        street_name, _, street_number = address_string_remainder.rpartition(' ')
        address_numbers.each do |address_number|
          address_objects << Address.find_or_initialize_by(street_name: street_name, street_number: address_number)
        end
      else
        raise ParsingError::AddressError.new(address_string: address_string)
      end
    end
    super(address_objects)
  end
end

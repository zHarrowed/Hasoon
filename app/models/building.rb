# frozen_string_literal: true

class Building < ApplicationRecord
  has_many :addresses, dependent: :destroy, autosave: true

  def addresses=(addresses_array)
    address_objects = []
    addresses_array.each do |address_string|
      ParseAddressService.new(address_string).call.each do |address_hash|
        address_objects << Address.find_or_initialize_by(address_hash)
      end
    end
    super(address_objects)
  end
end

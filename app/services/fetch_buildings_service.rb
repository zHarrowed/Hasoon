# frozen_string_literal: true

require 'http'

class FetchBuildingsService
  def call
    response = HTTP.get('https://www.haso.fi/fi/kohteet')
    data = Nokogiri::HTML(response.body.to_s)
    data.xpath("(//div[@id='result-table']/table[contains(@class,'expanded')]//tr)[position()>=2]")
        .map(&:children)
        .each do |building_data, address_data, quarter|
      building_data = building_data.children.first
      slug = building_data.attributes.first[1].value.split('/').last
      name = building_data.children.first.to_s
      addresses = address_data.children.first.to_s.split('/')
      quarter = quarter.children.first.to_s
      building = Building.find_or_initialize_by(name: name)
      building.assign_attributes(slug: slug, quarter: quarter, addresses: addresses)
      building.save!
    end
  end
end

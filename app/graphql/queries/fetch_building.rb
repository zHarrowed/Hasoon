module Queries
  class FetchBuilding < Queries::BaseQuery
    type Types::BuildingType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Building.find(id)
    end
  end
end

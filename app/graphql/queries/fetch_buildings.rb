module Queries
  class FetchBuildings < Queries::BaseQuery

    type [Types::BuildingType], null: false

    def resolve
      Building.all.order(created_at: :desc)
    end
  end
end

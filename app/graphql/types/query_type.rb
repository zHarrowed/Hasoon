module Types
  class QueryType < Types::BaseObject

    field :fetch_buildings, resolver: Queries::FetchBuildings
    field :fetch_building, resolver: Queries::FetchBuilding
  end
end

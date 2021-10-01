module Types
  class MutationType < Types::BaseObject
    field :add_building, mutation: Mutations::AddBuilding
  end
end

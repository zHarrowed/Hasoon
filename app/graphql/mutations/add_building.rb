module Mutations
  class AddBuilding < Mutations::BaseMutation
    argument :params, Types::Input::BuildingInputType, required: true

    field :building, Types::BuildingType, null: false

    def resolve(params:)
      building_params = Hash params

      building = Building.create!(building_params)

      { building: building }
    end
  end
end

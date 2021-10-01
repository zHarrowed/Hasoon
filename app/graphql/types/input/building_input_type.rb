module Types
  module Input
    class BuildingInputType < Types::BaseInputObject
      argument :name, String, required: true
    end
  end
end

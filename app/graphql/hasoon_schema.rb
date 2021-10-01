class HasoonSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  rescue_from(ActiveRecord::RecordNotFound) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, "#{field.type.unwrap.graphql_name} not found"
  end

  rescue_from(ActiveRecord::RecordInvalid) do |err, obj, args, ctx, field|
    raise GraphQL::ExecutionError, "Invalid attributes for #{field.type.unwrap.graphql_name}:"\
        " #{err.record.errors.full_messages.join(', ')}"
  end
end


class BillerBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :biller_id, :created_at, :updated_at

  field :plans do |biller, _options|
    biller.plans
  end
end

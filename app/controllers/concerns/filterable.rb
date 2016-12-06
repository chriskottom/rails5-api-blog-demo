module Filterable
  extend ActiveSupport::Concern

  private

  def filter_results(relation, attribute_name, attribute_value)
    relation.where(attribute_name => attribute_value)
  end
end

module Sortable
  extend ActiveSupport::Concern

  private

  # Accepts one or more String arguments in the form "-id" which
  # are translated into ordering directives for the given relation.
  def sort_results(relation, *sorts)
    sorts.each do |sort|
      order = (sort =~ /^\-/ ? 'DESC' : 'ASC')
      field = sort.sub(/^-/, '')
      if relation.has_attribute?(field)
        relation = relation.order("#{ field } #{ order }")
      end
    end

    relation
  end
end

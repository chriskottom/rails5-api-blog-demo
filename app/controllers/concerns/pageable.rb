module Pageable
  extend ActiveSupport::Concern

  private

  def page_number
    (params.dig(:page, :number) || 1).to_i
  end

  def pagination_meta(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count
    }
  end
end

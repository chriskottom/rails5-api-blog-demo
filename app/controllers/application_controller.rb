class ApplicationController < ActionController::API
  include ErrorRendering
  include RequestValidation

  DEFAULT_META = { licence: 'CC-0', authors: ['CK1'] }

  before_action :check_header

  private

  def default_meta
    if respond_to?(:pagination_meta)
      DEFAULT_META.MERGE(pagination_meta)
    else
      DEFAULT_META
    end
  end
end

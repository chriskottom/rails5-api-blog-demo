class ApplicationController < ActionController::API
  include ErrorRendering
  include RequestValidation

  before_action :check_header
  before_action :validate_login

  private

  def default_meta
    attributes = {
      licence: 'CC-0',
      authors: ['CK1'],
      logged_in: (@current_user ? true : false)
    }
  end
end

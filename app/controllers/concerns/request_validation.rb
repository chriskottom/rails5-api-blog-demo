module RequestValidation
  extend ActiveSupport::Concern

  private

  def check_header
    if %w(POST PUT PATCH).include? request.method
      if request.content_type != 'application/vnd.api+json'
        head 406 and return
      end
    end
  end

  def validate_type
    if params.dig('data', 'type') == params[:controller]
      return true
    else
      head 409 and return
    end
  end

  def validate_user
    token = request.headers['X-Api-Key']
    head 403 and return unless token

    user = User.find_by(token: token)
    head 403 and return unless user
  end
end

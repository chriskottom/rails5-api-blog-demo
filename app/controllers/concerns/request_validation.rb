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

  def validate_login
    token = request.headers['X-Api-Key']
    return unless token

    user = User.find_by(token: token)
    return unless user

    if 15.minutes.ago < user.updated_at
      user.touch
      @current_user = user
    end
  end

  def validate_user
    head 403 and return unless @current_user
  end
end

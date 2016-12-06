module ErrorRendering
  extend ActiveSupport::Concern

  private

  def render_error(resource, status)
    render json: resource, status: status, adapter: :json_api,
           serializer: ActiveModel::Serializer::ErrorSerializer
  end
end

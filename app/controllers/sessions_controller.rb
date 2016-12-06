class SessionsController < ApplicationController
  def create
    data = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    logger.error params.to_yaml

    user = User.find_by(full_name: data[:full_name])
    head 406 and return unless user

    if user.authenticate(data[:password])
      user.regenerate_token
      render json: user,
             status: :created,
             meta: default_meta,
             serializer: SessionSerializer
      return
    end
    head 403
  end

  def destroy
    user = User.find_by(token: params[:id])
    head 404 and return unless user

    user.regenerate_token
    head 204
  end
end

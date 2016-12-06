require 'json'

module APIHelpers
  def response_data
    return {} unless respond_to?(:response)
    data = JSON.parse response.body
  end
end

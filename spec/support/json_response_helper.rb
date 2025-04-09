module JsonResponseHelper
  def json_response
    response.parsed_body
  end
end
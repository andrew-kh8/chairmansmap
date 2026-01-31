module RequestHelpers
  def json_response
    @json_response ||= Oj.load(response.body, symbol_keys: true)
  end
end

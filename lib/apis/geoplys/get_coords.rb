module Apis
  module Geoplys
    class GetCoords
      include Dry::Monads[:result]

      URL = "pkk_files/geo2.php"

      def self.call(cadaster_number)
        result = Client.get(URL, {cn: cadaster_number})

        Dry::Monads::Success(result[:coordinates].first)
      rescue Client::ResponseError, Client::RequestError => error
        Dry::Monads::Failure(error)
      end
    end
  end
end

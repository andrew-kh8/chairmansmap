module Apis
  module Geoplys
    class GetCoords
      include Dry::Monads[:result]

      URL = "pkk_files/geo2.php"

      def call(cadaster_number)
        result = Client.get(URL, {cn: cadaster_number})

        Success(result[:coordinates].first)
      rescue Client::ResponseError => error
        Failure(error)
      end
    end
  end
end

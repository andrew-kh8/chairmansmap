# typed: strict

module OpenTopo
  class DestroyHeightFromVillage
    extend T::Sig

    sig { returns(Village) }
    attr_reader :village

    sig { params(village: Village).void }
    def initialize(village)
      @village = village
    end

    sig { returns(T::Boolean) }
    def call
      return true if !village.height_map?

      village.height_map_attacher.set(nil)
      village.save
    end
  end
end

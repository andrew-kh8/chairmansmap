# typed: false

class Village
  sig { returns(T.untyped) }
  def height_map
  end

  sig { params(value: T.untyped).void }
  def height_map=(value)
  end

  sig { returns(Shrine::Attacher) }
  def height_map_attacher
  end

  sig { returns(T.nilable(String)) }
  def height_map_url
  end
end

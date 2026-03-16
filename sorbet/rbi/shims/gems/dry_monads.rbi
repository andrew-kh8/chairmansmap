# typed: strict

# Adds type_member declarations to Dry::Monads types for Sorbet generics support.
# Without this, Dry::Monads::Result[FailureType, SuccessType] syntax doesn't work.

class Dry::Monads::Result
  extend T::Generic

  FailureType = type_member
  SuccessType = type_member

  sig { returns(T::Boolean) }
  def success?
  end

  sig { returns(T::Boolean) }
  def failure?
  end

  sig { returns(SuccessType) }
  def success
  end

  sig { returns(FailureType) }
  def failure
  end

  sig do
    type_parameters(:U)
      .params(blk: T.proc.params(arg: SuccessType).returns(Dry::Monads::Result[FailureType, T.type_parameter(:U)]))
      .returns(Dry::Monads::Result[FailureType, T.type_parameter(:U)])
  end
  def bind(&blk)
  end

  sig do
    type_parameters(:U)
      .params(blk: T.proc.params(arg: SuccessType).returns(T.type_parameter(:U)))
      .returns(Dry::Monads::Result[FailureType, T.type_parameter(:U)])
  end
  def fmap(&blk)
  end

  sig do
    type_parameters(:U)
      .params(
        val: T.nilable(T.type_parameter(:U)),
        blk: T.nilable(T.proc.params(arg: FailureType).returns(T.type_parameter(:U)))
      )
      .returns(T.any(SuccessType, T.type_parameter(:U)))
  end
  def value_or(val = nil, &blk)
  end
end

class Dry::Monads::Result::Success < ::Dry::Monads::Result
  extend T::Generic

  FailureType = type_member
  SuccessType = type_member
end

class Dry::Monads::Result::Failure < ::Dry::Monads::Result
  extend T::Generic

  FailureType = type_member
  SuccessType = type_member
end

class Dry::Monads::Maybe
  extend T::Generic

  Elem = type_member

  sig { returns(T::Boolean) }
  def success?
  end

  sig { returns(T::Boolean) }
  def failure?
  end

  sig { returns(Elem) }
  def value!
  end

  sig do
    type_parameters(:U)
      .params(blk: T.proc.params(arg: Elem).returns(Dry::Monads::Maybe[T.type_parameter(:U)]))
      .returns(Dry::Monads::Maybe[T.type_parameter(:U)])
  end
  def bind(&blk)
  end

  sig do
    type_parameters(:U)
      .params(blk: T.proc.params(arg: Elem).returns(T.type_parameter(:U)))
      .returns(Dry::Monads::Maybe[T.type_parameter(:U)])
  end
  def fmap(&blk)
  end

  sig do
    type_parameters(:U)
      .params(
        val: T.nilable(T.type_parameter(:U)),
        blk: T.nilable(T.proc.returns(T.type_parameter(:U)))
      )
      .returns(T.any(Elem, T.type_parameter(:U)))
  end
  def value_or(val = nil, &blk)
  end
end

class Dry::Monads::Maybe::Some < ::Dry::Monads::Maybe
  extend T::Generic

  Elem = type_member
end

class Dry::Monads::Maybe::None < ::Dry::Monads::Maybe
  extend T::Generic

  Elem = type_member
end

module Dry::Monads::Result::Mixin::Constructors
  sig { params(value: T.untyped, block: T.untyped).returns(Dry::Monads::Result::Success[T.untyped, T.untyped]) }
  def Success(value = nil, &block)
  end

  sig { params(value: T.untyped, block: T.untyped).returns(Dry::Monads::Result::Failure[T.untyped, T.untyped]) }
  def Failure(value = nil, &block)
  end
end

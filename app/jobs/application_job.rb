# typed: strict

class ApplicationJob
  include Sidekiq::Job
  extend T::Sig
end

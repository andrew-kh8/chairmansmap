# typed: strict

class MainMapController < ApplicationController
  extend T::Sig

  sig { void }
  def index
    render :index
  end
end

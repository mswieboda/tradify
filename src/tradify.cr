require "cray"
require "./tradify/*"

module Tradify
  def self.run
    Game.new.run
  end
end

Tradify.run

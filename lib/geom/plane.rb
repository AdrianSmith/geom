require 'geom/tolerance'
require 'geom/vector'
require 'geom/point'

module Geom
  class Plane
    attr_accessor :x, :y, :z

    def initialize *args
      @x, @y, @z = args.flatten
    end

  end
end

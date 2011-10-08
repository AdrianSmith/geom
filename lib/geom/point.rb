require 'geom/tolerance'
require 'geom/vector'

module Geom
  class Point
    attr_accessor :x, :y, :z

    def initialize *args
      @x, @y, @z = args.flatten
    end

    def - point
      Point.new(@x - point.x, @y - point.y, @z - point.z)
    end

    def + point
      Point.new(@x + point.x, @y + point.y, @z + point.z)
    end

    def == point
      (@x - point.x).abs < TOLERANCE && (@y - point.y).abs < TOLERANCE && (@z - point.z).abs < TOLERANCE
    end

    alias_method :eql?, :==
    alias_method :coincident?, :==

    def hash
      @x.to_int ^ @y.to_int ^ @z.to_int
    end

    def distance(point)
      x_dist = @x - point.x
      y_dist = @y - point.y
      z_dist = @z - point.z
      Math.sqrt(x_dist * x_dist + y_dist * y_dist + z_dist * z_dist);
    end

    def translate(direction, distance=1)
      transation_vector = direction.unitize.scale distance
      Point.new(@x += transation_vector.x, @y += transation_vector.y, @z += transation_vector.z)
    end

    def project_along(plane, vector)
    end

    def project(plane)
      n = plane.normal
      q = self.to_vector

      r = (q.dot(n) - plane.d) / n.length

      result = q - n.unitize.scale(r)
      result.to_point
    end

    def between?(first_point, second_point)
    end

    def self.remove_coincident(points)
      points.uniq
    end

    def self.collinear(points)
    end

    def self.average(points)
      tx, ty, tz = 0, 0, 0
      num = points.size.to_f
      points.each do |point|
        tx += point.x
        ty += point.y
        tz += point.z
      end
      Point.new(tx/num, ty/num, tz/num)
    end

    def to_vector
      Vector.new(@x,@y,@z)
    end

    def to_s
      "Point(%.3f,%.3f,%.3f)" % [@x, @y, @z]
    end

    def to_ary
      [@x, @y, @z]
    end

  end
end

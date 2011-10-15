module Geom
  class RectangularCoordinateSystem
    attr_accessor :origin, :x_vector, :y_vector, :z_vector

    def initialize
      @origin = Point.new(0,0,0)
      @x_vector = Vector.new(1,0,0)
      @y_vector = Vector.new(0,1,0)
      @z_vector = Vector.new(0,0,1)
    end

    def self.new_from_xvector_and_xyplane(origin, axis_vector, plane_vector)
      rcs = self.new
      rcs.origin = origin
      rcs.x_vector = axis_vector.unitize
      rcs.y_vector = plane_vector.unitize
      rcs.z_vector = rcs.x_vector.cross(rcs.y_vector).unitize
      rcs.y_vector = rcs.z_vector.cross(rcs.x_vector).unitize
      rcs
    end

    def self.new_from_yvector_and_yzplane(origin, axis_vector, plane_vector)
      rcs = self.new
      rcs.origin = origin
      rcs.y_vector = axis_vector.unitize
      rcs.x_vector = plane_vector.unitize
      rcs.z_vector = rcs.x_vector.cross(rcs.y_vector).unitize
      rcs.x_vector = rcs.y_vector.cross(rcs.z_vector).unitize
      rcs
    end

    def self.new_from_zvector_and_zxplane(origin, axis_vector, plane_vector)
      rcs = self.new
      rcs.origin = origin
      rcs.z_vector = axis_vector.unitize
      rcs.y_vector = plane_vector.unitize
      rcs.x_vector = rcs.y_vector.cross(rcs.z_vector).unitize
      rcs.y_vector = rcs.z_vector.cross(rcs.x_vector).unitize
      rcs
    end

    def transformation_matrix
      Matrix[
        [@x_vector.x, @x_vector.Y, @x_vector.Z, 0],
        [@y_vector.x, @y_vector.Y, @y_vector.Z, 0],
        [@z_vector.x, @z_vector.Y, @z_vector.Z, 0],
        [@origin.x, @origin.Y, @origin.Z, 1]
      ]
    end

    def to_s
      "RCS[#{@origin.to_s} X-#{@x_vector.to_s} Y-#{@y_vector.to_s} Z-#{@z_vector.to_s}]"
    end

    def == rcs
      rcs.x_vector == @x_vector &&
      rcs.y_vector == @y_vector &&
      rcs.z_vector == @z_vector &&
      rcs.origin == @origin
    end

    alias_method :eql?, :==

    def hash
      @x_vector.hash ^ @y_vector.hash ^ @z_vector.hash ^ @origin.hash
    end
  end
end
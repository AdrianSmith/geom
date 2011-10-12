module Geom
  class RectangularCoordinateSystem
    attr_accessor :origin, :vector_x, :vector_y, :vector_z

    def initialize
      @origin = Point.new(0,0,0)
      @vector_x = Vector.new(1,0,0)
      @vector_y = Vector.new(0,1,0)
      @vector_z = Vector.new(0,0,1)
    end

    def self.create_xvector_yvector(origin, vector_x, vector_y)
      rcs = self.new
      rcs.origin = origin
      rcs.vector_x = vector_x.unitize
      rcs.vector_y = vector_y.unitize
      rcsvector_z = vector_x.cross(vector_y)
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
      "RCS[#{@origin.to_s} X-#{@vector_x.to_s} Y-#{@vector_y.to_s} Z-#{@vector_z.to_s}]"
    end

    def == rcs
      rcs.vector_x == @vector_x &&
      rcs.vector_y == @vector_y &&
      rcs.vector_z == @vector_z &&
      rcs.origin == @origin
    end

    alias_method :eql?, :==

    def hash
      @vector_x.hash ^ @vector_y.hash ^ @vector_z.hash ^ @origin.hash
    end
  end
end
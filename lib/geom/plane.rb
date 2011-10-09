module Geom
  class Plane
    # Plane defined by the equation:Ax + By + Cz = D
    attr_accessor :a, :b, :c, :d

    def initialize *args

      case args.size
      when 2 # Point and normal vector
        point = args[0]
        normal = args[1]

        @a = normal.x
        @b = normal.y
        @c = normal.z
        @d = ((normal.x * point.x) + ((normal.y * point.y) + (normal.z * point.z)))

      when 3 # Points on the plane
        point_1 = args[0]
        point_2 = args[1]
        point_3 = args[2]

        vector_12 = Vector.new(point_1, point_2)
        vector_13 = Vector.new(point_1, point_3)
        plane_normal = vector_12.cross(vector_13)

        @a = plane_normal.x
        @b = plane_normal.y
        @c = plane_normal.z
        @d = ((point_1.x * @a) + ((point_1.y * @b) + (point_1.z * @c)))

      else # Coefficients of plane equation
        @a, @b, @c, @d = args.flatten
      end
      self.normalize
    end

    def == plane
      (@a - plane.a).abs < TOLERANCE &&
      (@b - plane.b).abs < TOLERANCE &&
      (@c - plane.c).abs < TOLERANCE &&
      (@d - plane.d).abs < TOLERANCE
    end

    alias_method :eql?, :==

    def hash
      @a.to_int ^ @b.to_int ^ @c.to_int ^ @d.to_int
    end

    def normal
      Vector.new(@a, @b, @c).unitize
    end

    def line_on?(line)
      (this.point_on?(line.point_at_parameter(0) && this.point_on?(line.point_at_parameter(1)))) ? true : false
    end

    def distance_to(point)
      n = Vector.new(@a, @b, @c)
      l = n.length
      d = (@d / (l * l))
      pnt = Point.new((@a * d), (@b * d), (@c * d))
      vec = Vector.new(point, pnt)
      vec.dot(n) / l
    end

    def to_s
      "Plane(%.3f,%.3f,%.3f,%.3f)" % [@a, @b, @c, @d]
    end

    def normalize
      if (@a == 0 && @b == 0 && @c == 0)
        raise ArgumentError.new("Plane definition error, points may be coincident or collinear")
      else
        norm_factor = 1.0 / Math.sqrt((@a * @a + @b * @b + @c * @c))
        @a *= norm_factor
        @b *= norm_factor
        @c *= norm_factor
        @d *= norm_factor
      end
    end

  end
end

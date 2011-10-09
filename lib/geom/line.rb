module Geom
  class Line
    # Line defined by parametric equations X = X0 + XAt, Y = Y0 + YAt, ,Z = Z0 + ZAt
    attr_accessor :x0, :xa, :y0, :ya, :z0, :za

    def initialize *args

      case args.size
      when 2 # Start point and End point
        start_point = args[0]
        end_point = args[1]

        line_direction = Vector.new(start_point, end_point)

        @x0 = start_point.x
        @y0 = start_point.y
        @z0 = start_point.z
        @xa = line_direction.x
        @ya = line_direction.y
        @za = line_direction.z

      else # Coefficients of line equation
        @x0, @xa, @y0, @ya, @z0, @za = args.flatten
      end
    end

    def == line
      (@x0 - line.x0).abs < TOLERANCE &&
      (@y0 - line.y0).abs < TOLERANCE &&
      (@z0 - line.z0).abs < TOLERANCE &&
      (@xa - line.xa).abs < TOLERANCE &&
      (@ya - line.ya).abs < TOLERANCE &&
      (@za - line.za).abs < TOLERANCE
    end

    alias_method :eql?, :==

    def hash
      @a.to_int ^ @b.to_int ^ @c.to_int ^ @d.to_int
    end

    def direction
      Vector.new(point_at_parameter(0), point_at_parameter(1))
    end

    def point_at_parameter(t)
      Point.new((@x0 + @xa * t), (@y0 + @ya * t), (@z0 + @za * t))
    end

    def parameter_at_point(point)
      if (@xa != 0)
        ((point.x - @x0) / @xa)
      elsif (@ya != 0)
        ((point.y - @y0) / @ya)
      else
        ((point.z - @z0) / @za)
      end
    end

    def closest_approach_parameter(line)
      if self.direction.parallel?(line.direction)
        raise ArgumentError.new("Lines are parallel")
      else
        s1 = Vector.new(@x0, @y0, @z0)
        v1 = Vector.new(@xa, @ya, @za)
        s2 = Vector.new(line.x0, line.y0, line.z0)
        v2 = Vector.new(line.xa, line.ya, line.za)

        i = 1 / ((v1.dot(v2) * v1.dot(v2)) - (v1.length * v1.length) * (v2.length * v2.length))
        j11 = -(v2.length * v2.length)
        j12 = v1.dot(v2)

        vk = Vector.new(s1, s2)

        k1 = vk.dot(v1)
        k2 = vk.dot(v2)

        i * (j11 * k1 + j12 * k2)
      end
    end

    def intersection_with_line(line)
      t1 = self.closest_approach_parameter(line)
      t2 = line.closest_approach_parameter(self)

      p1 = self.point_at_parameter(t1)
      p2 = line.point_at_parameter(t2)

      dist = p1.distance_to_point(p2)

      if (dist < TOLERANCE)
        p1
      else
        puts line.to_s
        puts self.to_s
        puts p1.to_s
        puts p2.to_s
        raise ArgumentError.new("Lines do not intersect")
      end
    end

    def intersection_with_plane(plane)
      var = [0,0]
      var[0] = @x0 * plane.a + @y0 * plane.b + @z0 * plane.c
      var[1] = @xa * plane.a + @ya * plane.b + @za * plane.c

      raise ArgumentError.new("Line is parallel to the plane") if var[1] == 0

      t = (plane.d - var[0]) / var[1]
      Point.new((@x0 + @xa * t), (@y0 + @ya * t), (@z0 + @za * t))
    end

    def on_plane?(plane)
      (self.point_at_parameter(0).on_plane?(plane) && self.point_at_parameter(1).on_plane?(plane)) ? true : false
    end

    def to_s
      "Line(%.3f,%.3f,%.3f,%.3f,%.3f,%.3f)" % [@x0, @xa, @y0, @ya, @z0, @za]
    end

  end
end

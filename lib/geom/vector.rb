module Geom
  # Vector defined by coordinates x, y, z
  class Vector
    attr_accessor :x, :y, :z

    def initialize(*args)
      if args.size == 2
        @x = args[1].x.to_f - args[0].x.to_f
        @y = args[1].y.to_f - args[0].y.to_f
        @z = args[1].z.to_f - args[0].z.to_f
      else
        @x, @y, @z = args.flatten
      end
    end

    def -(vector)
      Vector.new(@x - vector.x, @y - vector.y, @z - vector.z)
    end

    def +(vector)
      Vector.new(@x + vector.x, @y + vector.y, @z + vector.z)
    end

    def *(scale)
      Vector.new(@x * scale, @y * scale, @z * scale)
    end

    def ==(vector)
      (@x - vector.x).abs < TOLERANCE &&
      (@y - vector.y).abs < TOLERANCE &&
      (@z - vector.z).abs < TOLERANCE
    end

    alias_method :eql?, :==

    def hash
      (@x.to_int ^ @y.to_int ^ @z.to_int)
    end

    alias_method :scale, :*

    def **(power)
      Vector.new(@x ** power, @y ** power, @z ** power)
    end

    def /(scale)
      self * (1.0/scale)
    end

    def dot(vector)
      @x * vector.x + @y * vector.y + @z * vector.z
    end

    def cross(vector)
      Vector.new(@y * vector.z - @z * vector.y,
      @z * vector.x - @x * vector.z,
      @x * vector.y - @y * vector.x)
    end

    def unitize
      self / self.length
    end

    def reverse
      Vector.new(-@x, -@y, -@z)
    end

    def length
      Math.sqrt(self.dot(self))
    end

    def rotate(ref_vector, angle)
      r = [[0,0,0],[0,0,0],[0,0,0]]
      c = Math.cos(angle)
      s = Math.sin(angle)

      unit_ref_vector = ref_vector.unitize

      ax = unit_ref_vector.x
      ay = unit_ref_vector.y
      az = unit_ref_vector.z

      r[0][0] = (c + ((1 - c) * (ax * ax)))
      r[0][1] = (((1 - c) * (ax * ay)) - (s * az))
      r[0][2] = (((1 - c) * (ax * az)) + (s * ay))
      r[1][0] = (((1 - c) * (ax * ay)) + (s * az))
      r[1][1] = (c + ((1 - c) * (ay * ay)))
      r[1][2] = (((1 - c) * (ay * az)) - (s * ax))
      r[2][0] = (((1 - c) * (ax * az)) - (s * ay))
      r[2][1] = (((1 - c) * (ay * az)) + (s * ax))
      r[2][2] = (c + ((1 - c) * (az * az)))

      vx = ((r[0][0] * @x) + ((r[0][1] * @y) + (r[0][2] * @z)))
      vy = ((r[1][0] * @x) + ((r[1][1] * @y) + (r[1][2] * @z)))
      vz = ((r[2][0] * @x) + ((r[2][1] * @y) + (r[2][2] * @z)))

      Vector.new(vx, vy, vz)
    end

    def angle_between(vector)
      # One of the vectors is a zero vector
      return nil if ((vector.length == 0) || (self.length == 0))

      dot = self.dot(vector)
      val = dot / (self.length * vector.length)

      if (val > 1.0)
        # Would result in NaN
        0.0
      else
        Math.acos(val)
      end
    end

    # If dot product > 0, angle is acute and vectors are the same direction
    # If dot product < 0, angle is obtuse and vectors are in opposite direction
    # If dot product = 0, vectors are orthogonal, including if one is zero vector (taken as same direction)
    def same_direction?(vector)
      dotp = self.dot(vector);
      dotp > 0
    end

    def parallel?(vector)
      angle = self.angle_between(vector)
      ((angle - Math::PI).abs < TOLERANCE) || (angle.abs < TOLERANCE)
    end

    def zero?
      self.length <= 0.0
    end

    def unitity?
      self.x == 1.0 && self.x == 1.0 && self.z == 1.0
    end

    def self.average(vectors)
      num = vectors.size.to_f
      Vector.sum(vectors).scale(1/num)
    end

    def self.sum(vectors)
      tx, ty, tz = 0, 0, 0
      vectors.each do |vector|
        tx += vector.x
        ty += vector.y
        tz += vector.z
      end
      Vector.new(tx, ty, tz)
    end

    def to_point
      Point.new(@x,@y,@z)
    end

    def to_s
      "Vector(%.3f,%.3f,%.3f)" % [@x, @y, @z]
    end

    def to_ary
      [@x, @y, @z]
    end
  end
end

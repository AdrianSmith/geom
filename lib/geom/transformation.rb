module Geom
  # 3D transformation object that is composed of a 4x4 matrix representing the
  # rotation and translation components
  # rx1  ry1  rz1  tx
  # rx2  ry2  rz2  ty
  # rx3  ry3  rz3  tz
  #   0    0    0   1
  # Transformations are applied by using the * operator
  # Available transformations include scaling, translation, reflection, rotation
  class Transformation
    attr_accessor :type, :matrix, :translation_vector

    ROTATION = 1
    TRANSLATION = 2
    ISOMETRIC = 4
    REFLECTION = 8
    SCALING = 16

    def initialize(source_coordinate_system, target_coordinate_system)
      source = target_coordinate_system.transformation_matrix
      target = source_coordinate_system.transformation_matrix

      @matrix = target.inverse * source
      @translation_vector = Vector.new(source_coordinate_system.origin, target_coordinate_system.origin)

      @type |= ROTATION if self.identity?
      @type |= TRANSLATION if @translation_vector.zero?

      if self.transformation_orthogonal_matrix? && self.rotation_submatrix_diagonal?
        @type |= SCALING
        @type |= ISOMETRIC
      elsif self.transformation_orthogonal_matrix?
        @type |= ROTATION
        @type |= ISOMETRIC
      elsif self.rotation_submatrix_diagonal?
        @type |= SCALING
      else
        raise ArgumentError, "Transformation is non-linear"
      end
    end

    def transformation_orthogonal_matrix?
      @matrix * @matrix == Matrix.identity(4)
    end

    def rotation_submatrix_diagonal?
      @matrix[1,0] == 0 && @matrix[2,0] == 0 && @matrix[2,1] == 0
    end

    def identity?
      @matrix == Matrix.identity(4)
    end

    def isometric?
      ISOMETRIC & self.type > 0
    end

    def scaling?
      SCALING & self.type > 0
    end

    def reflection?
      REFLECTION & self.type > 0
    end

    def transformation?
      TRANSFORMATION & self.type > 0
    end

    def translation?
      TRANSLATION & self.type > 0
    end

    def rotation?
      ROTATION & self.type > 0
    end

    def scale
      if self.scaling?
        @matrix[0]
      else
        raise ArgumentError, "Transformation does not scale"
      end
    end

    def rotation_angle
      trace = self.matrix[0] + self.matrix[5] + self.matrix[10]
      cos = 0.5 * (trace - 1)
      Math.cos(cos)
    end

    def rotation_axis
      axis = []
      angle = 0
      Vector.new(self.matrix[])

      @matrix.rotation_angle
      Vector.new(axis[0], axis[1], axis[2])
    end

  end
end

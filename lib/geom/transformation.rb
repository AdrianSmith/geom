module Geom
  # 3D transformation object that is composed of a 4x4 matrix representing the
  # rotation and translation components
  # rx1  ry1  rz1  tx
  # rx2  ry2  rz2  ty
  # rx3  ry3  rz3  tz
  #   0    0    0   1
  # Transformations are applied by using the * operator
  # Available transformations include translation and rotation
  class Transformation
    attr_accessor :type, :matrix, :translation_vector

    ROTATION = 1
    TRANSLATION = 2
    SCALING = 4

    def initialize(coordinate_system)
      @matrix = coordinate_system.transformation_matrix * 1.0 # ensure initialization as float not integer
      @translation_vector = Vector.new(Point.new(0.0, 0.0, 0.0), coordinate_system.origin)
      @type = 0 # initialize as integer not boolean

      @type |= ROTATION if self.rotation_submatrix_orthogonal? && !rotation_submatrix_identity?
      @type |= TRANSLATION unless self.translation_vector.zero?
      @type |= SCALING unless self.scale_vector.unitity?

      raise ArgumentError, "Transformation is non-linear" unless self.rotation_submatrix_orthogonal? or self.rotation_submatrix_diagonal
    end

    def type_description
      names = ["Type #{@type}"]
      names << 'Scaling' if self.scaling?
      names << 'Translation' if self.translation?
      names << 'Rotation' if self.rotation?
      names.to_s
    end

    def rotation_submatrix
      @matrix.minor(0..2,0..2)
    end

    def rotation_submatrix_orthogonal?
      self.rotation_submatrix.transpose == self.rotation_submatrix.inverse
    end

    def rotation_submatrix_diagonal?
      @matrix[1,0] == 0.0 && @matrix[2,0] == 0.0 && @matrix[2,1] == 0.0 &&
      @matrix[0,1] == 0.0 && @matrix[0,2] == 0.0 && @matrix[1,2] == 0.0 &&
      @matrix[0,0].abs > TOLERANCE && @matrix[1,1].abs > TOLERANCE && @matrix[2,2].abs > TOLERANCE
    end

    def identity?
      @matrix == Matrix.identity(4) * 1.0
    end

    def rotation_submatrix_identity?
      self.rotation_submatrix == Matrix.identity(3) * 1.0
    end

    def scaling?
      SCALING & self.type > 0.0
    end

    def translation?
      TRANSLATION & self.type > 0.0
    end

    def rotation?
      ROTATION & self.type > 0.0
    end

    def scale_vector
      Vector.new(
        Math.sqrt(@matrix[0,0]*@matrix[0,0] + @matrix[0,1]*@matrix[0,1] + @matrix[0,2]*@matrix[0,2]),
        Math.sqrt(@matrix[1,0]*@matrix[1,0] + @matrix[1,1]*@matrix[1,1] + @matrix[1,2]*@matrix[1,2]),
        Math.sqrt(@matrix[2,0]*@matrix[2,0] + @matrix[2,1]*@matrix[2,1] + @matrix[2,2]*@matrix[2,2])
        )
    end

    def to_s(pretty=false)
      unless pretty
        "Transform #{@matrix.to_s}"
      else
        str = "Transform\n"
        str += "    Vx    |     Vy    |     Vz    |      T\n"
        str += sprintf("%9.2e | %9.2e | %9.2e | %9.2e\n", @matrix[0,0], @matrix[0,1], @matrix[0,2], @matrix[0,3])
        str += sprintf("%9.2e | %9.2e | %9.2e | %9.2e\n", @matrix[1,0], @matrix[1,1], @matrix[1,2], @matrix[1,3])
        str += sprintf("%9.2e | %9.2e | %9.2e | %9.2e\n", @matrix[2,0], @matrix[2,1], @matrix[2,2], @matrix[2,3])
        str += sprintf("%9.2e | %9.2e | %9.2e | %9.2e",   @matrix[3,0], @matrix[3,1], @matrix[3,2], @matrix[3,3])
        str
      end
    end
  end
end
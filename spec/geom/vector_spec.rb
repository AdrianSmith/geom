require_relative '../spec_helper.rb'
require 'geom/vector'

module Geom
  describe Vector do
    before do
      @valid_attributes = [1.1, -2, 10]
    end

    describe "Construction" do
      it "should create a valid instance from an array of coordinates" do
        vector = Vector.new(@valid_attributes)
        expect(vector.x).to eq(@valid_attributes[0])
        expect(vector.y).to eq(@valid_attributes[1])
        expect(vector.z).to eq(@valid_attributes[2])
      end

      it "should create a valid instance from three numbers" do
        vector = Vector.new(@valid_attributes[0], @valid_attributes[1], @valid_attributes[2])
        expect(vector.x).to eq(@valid_attributes[0])
        expect(vector.y).to eq(@valid_attributes[1])
        expect(vector.z).to eq(@valid_attributes[2])
      end

      it "should create a valid instance from two points" do
        from_point = Point.new(0,-3,-1)
        to_point = Point.new(3,-3,6)
        result = Vector.new(3,0,7)
        expect(Vector.new(from_point, to_point)).to eq(result)
      end
    end

    describe "Arithmetic" do
      before do
        @first_vector  = Vector.new(0,0,0)
        @second_vector = Vector.new(1,2,3)
      end

      it "should allow addition with another vector" do
        result = @first_vector + @second_vector
        expect(result.x).to eq(1)
        expect(result.y).to eq(2)
        expect(result.z).to eq(3)
      end

      it "should allow subtraction with another vector" do
        result = @first_vector - @second_vector
        expect(result.x).to eq(-1)
        expect(result.y).to eq(-2)
        expect(result.z).to eq(-3)
      end

      it "should calculate dot product" do
        v1 = Vector.new(3, -2, 1)
        v2 = Vector.new(0, 2, 4)
        expect(v1.dot(v2)).to eq(0.0)
      end

      it "should calculate cross product" do
        v1 = Vector.new(1, 0, 0)
        v2 = Vector.new(0, 1, 0)
        expect(v1.cross(v2)).to eq(Vector.new(0, 0, 1))

        v3 = Vector.new(2, 1, 1)
        v4 = Vector.new(-4, 3, 1)
        expect(v3.cross(v4)).to eq(Vector.new(-2, -6, 10))
      end
    end

    it "should reverse direction" do
      expect(Vector.new(1,-1,9).reverse).to eq(Vector.new(-1,1,-9))
    end

    describe "should calculate angle to another vector" do
      before do
        @v1 = Vector.new(2, 0, 0)
        @v2 = Vector.new(0, -3, 0)
        @v3 = Vector.new(0, 3, 0)
        @v4 = Vector.new(-2, -2, 0)
        @v5 = Vector.new(0, 1, 0)
        @v6 = Vector.new(0, -1, 0)
      end

      it "when vectors are separated by 90 degrees and in fourth quadrant" do
        expect(@v1.angle_between(@v2)).to eq(Math::PI / 2)
      end

      it "when vectors are separated by 90 degrees and in first quadrant" do
        expect(@v1.angle_between(@v3)).to eq(Math::PI / 2)
      end

      it "when vectors are separated by 135 degrees and in the first and second quadrants" do
        expect(@v1.angle_between(@v4)).to eq(Math::PI * (3 / 4.0))
      end

      it "when vectors are separated by 180 degrees" do
        expect(@v5.angle_between(@v6)).to eq(Math::PI)
      end
    end

    describe "should determine if vectors have same direction" do
      before do
        @v1 = Vector.new(1, 0, 0)
        @v2 = Vector.new(1, 1, 0)
        @v3 = Vector.new(-1, 0.001, 0)
      end

      it "when vectors are 45 degrees apart" do
        expect(@v1.same_direction?(@v2)).to be_truthy
      end

      it "when vectors are 180 degrees apart" do
        expect(@v1.same_direction?(@v3)).to be_falsey
      end
    end

    describe "should determine if parallel with another vector" do
      before do
        @v1 = Vector.new(1, 0, 0)
        @v2 = Vector.new(-2, 0, 0)
        @v3 = Vector.new(-2, 0.001, 0)
      end
      it "when vectors are 180 degrees apart" do
        expect(@v1.parallel?(@v2)).to be_truthy
      end

      it "when vectors are slightly misaligned" do
        expect(@v1.parallel?(@v3)).to be_falsey
      end
    end

    it "should determine if zero vector" do
      v1 = Vector.new(0, 0, 0)
      v2 = Vector.new(-2, 0, 0)
      expect(v1.zero?).to be_truthy
      expect(v2.zero?).to be_falsey
    end

    it "should calculated the average of an array of vectors" do
      vectors = [Vector.new(0,0,0), Vector.new(1,1,1), Vector.new(10,-10,2)]
      average_vector = Vector.new(11/3.0, -9/3.0, 3/3.0)
      expect(Vector.average(vectors)).to eq(average_vector)
    end

    it "should calculated the sum of an array of vectors" do
      vectors = [Vector.new(0,0,0), Vector.new(1,1,1), Vector.new(10,-10,2)]
      result_vector = Vector.new(11, -9, 3)
      expect(Vector.sum(vectors)).to eq(result_vector)
    end

    it "should calculate a new vector rotated around an axis vector a supplied angle" do
      vector_1 = Vector.new(3.2, 0, 0)
      axis = Vector.new(0, 0, -1)
      vector_2 = vector_1.rotate(axis, (33 * Math::PI / 180))
      expect(vector_2.x).to be_within(0.001).of(2.684)
      expect(vector_2.y).to be_within(0.001).of(-1.743)
      expect(vector_2.z).to be_within(0.001).of(0.0)
    end

    describe "Return Types" do
      it "should return as point" do
        expect(Vector.new(@valid_attributes).to_point).to eq(Point.new(@valid_attributes))
      end

      it "should return as array" do
        expect(Vector.new(@valid_attributes).to_a).to eq(@valid_attributes)
      end
      it "should return a summary string" do
        expect(Vector.new(1,2,3).to_s).to eq("Vector(1.000,2.000,3.000)")
      end

      it "should return a hash code" do
        expect(Vector.new(1,2.88,-45.111).hash).to eq(-48)
      end
    end

    describe "Translation" do
    end

    describe "Transformation:" do
      it "should transform into a coordinate system" do
        v1 = Vector.new(2,2,0)
        p2 = Point.new(5,5,0)
        vx = Vector.new(1,0,0)
        vy = Vector.new(0,1,0)
        vz = Vector.new(0,0,1)
        rcs = RectangularCoordinateSystem.new_from_xvector_and_xyplane(p2, vy, vz)
        expect(v1.transform(rcs)).to eq(Vector.new(-3,3,0))
      end
    end

  end
end
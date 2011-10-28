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
        vector.x.should == @valid_attributes[0]
        vector.y.should == @valid_attributes[1]
        vector.z.should == @valid_attributes[2]
      end

      it "should create a valid instance from three numbers" do
        vector = Vector.new(@valid_attributes[0], @valid_attributes[1], @valid_attributes[2])
        vector.x.should == @valid_attributes[0]
        vector.y.should == @valid_attributes[1]
        vector.z.should == @valid_attributes[2]
      end

      it "should create a valid instance from two points" do
        from_point = Point.new(0,-3,-1)
        to_point = Point.new(3,-3,6)
        result = Vector.new(3,0,7)
        Vector.new(from_point, to_point).should == result
      end
    end

    describe "Arithmetic" do
      before do
        @first_vector  = Vector.new(0,0,0)
        @second_vector = Vector.new(1,2,3)
      end

      it "should allow addition with another vector" do
        result = @first_vector + @second_vector
        result.x.should == 1
        result.y.should == 2
        result.z.should == 3
      end

      it "should allow subtraction with another vector" do
        result = @first_vector - @second_vector
        result.x.should == -1
        result.y.should == -2
        result.z.should == -3
      end

      it "should calculate dot product" do
        v1 = Vector.new(3, -2, 1)
        v2 = Vector.new(0, 2, 4)
        v1.dot(v2).should == 0.0
      end

      it "should calculate cross product" do
        v1 = Vector.new(1, 0, 0)
        v2 = Vector.new(0, 1, 0)
        v1.cross(v2).should == Vector.new(0, 0, 1)

        v3 = Vector.new(2, 1, 1)
        v4 = Vector.new(-4, 3, 1)
        v3.cross(v4).should == Vector.new(-2, -6, 10)
      end
    end

    it "should reverse direction" do
      Vector.new(1,-1,9).reverse.should == Vector.new(-1,1,-9)
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
        @v1.angle_between(@v2).should == Math::PI / 2
      end

      it "when vectors are separated by 90 degrees and in first quadrant" do
        @v1.angle_between(@v3).should == Math::PI / 2
      end

      it "when vectors are separated by 135 degrees and in the first and second quadrants" do
        @v1.angle_between(@v4).should == Math::PI * (3 / 4.0)
      end

      it "when vectors are separated by 180 degrees" do
        @v5.angle_between(@v6).should == Math::PI
      end
    end

    describe "should determine if vectors have same direction" do
      before do
        @v1 = Vector.new(1, 0, 0)
        @v2 = Vector.new(1, 1, 0)
        @v3 = Vector.new(-1, 0.001, 0)
      end

      it "when vectors are 45 degrees apart" do
        @v1.same_direction?(@v2).should be_true
      end

      it "when vectors are 180 degrees apart" do
        @v1.same_direction?(@v3).should be_false
      end
    end

    describe "should determine if parallel with another vector" do
      before do
        @v1 = Vector.new(1, 0, 0)
        @v2 = Vector.new(-2, 0, 0)
        @v3 = Vector.new(-2, 0.001, 0)
      end
      it "when vectors are 180 degrees apart" do
        @v1.parallel?(@v2).should be_true
      end

      it "when vectors are slightly misaligned" do
        @v1.parallel?(@v3).should be_false
      end
    end

    it "should determine if zero vector" do
      v1 = Vector.new(0, 0, 0)
      v2 = Vector.new(-2, 0, 0)
      v1.zero?.should be_true
      v2.zero?.should be_false
    end

    it "should calculated the average of an array of vectors" do
      vectors = [Vector.new(0,0,0), Vector.new(1,1,1), Vector.new(10,-10,2)]
      average_vector = Vector.new(11/3.0, -9/3.0, 3/3.0)
      Vector.average(vectors).should == average_vector
    end

    it "should calculated the sum of an array of vectors" do
      vectors = [Vector.new(0,0,0), Vector.new(1,1,1), Vector.new(10,-10,2)]
      result_vector = Vector.new(11, -9, 3)
      Vector.sum(vectors).should == result_vector
    end

    it "should calculate a new vector rotated around an axis vector a supplied angle" do
      vector_1 = Vector.new(3.2, 0, 0)
      axis = Vector.new(0, 0, -1)
      vector_2 = vector_1.rotate(axis, (33 * Math::PI / 180))
      vector_2.x.should be_within(0.001).of(2.684)
      vector_2.y.should be_within(0.001).of(-1.743)
      vector_2.z.should be_within(0.001).of(0.0)
    end

    describe "Return Types" do
      it "should return as point" do
        Vector.new(@valid_attributes).to_point.should == Point.new(@valid_attributes)
      end

      it "should return as array" do
        Vector.new(@valid_attributes).to_ary.should == @valid_attributes
      end
      it "should return a summary string" do
        Vector.new(1,2,3).to_s.should == "Vector(1.000,2.000,3.000)"
      end

      it "should return a hash code" do
        Vector.new(1,2.88,-45.111).hash.should == -48
      end
    end

    describe "Translation" do
    end

    describe "Transformation" do
    end

  end
end
require_relative '../spec_helper.rb'
require 'geom/vector'

module Geom
  describe Vector do
    before(:each) do
      @valid_attributes = [1.1, -2, 10]
    end

    it "should create a valid instance from an array of coordinates" do
      test_vector = Vector.new(@valid_attributes)
      test_vector.x.should == @valid_attributes[0]
      test_vector.y.should == @valid_attributes[1]
      test_vector.z.should == @valid_attributes[2]
    end

    it "should create a valid instance from three numbers" do
      test_vector = Vector.new(@valid_attributes[0], @valid_attributes[1], @valid_attributes[2])
      test_vector.x.should == @valid_attributes[0]
      test_vector.y.should == @valid_attributes[1]
      test_vector.z.should == @valid_attributes[2]
    end

    it "should create a valid instance from two points" do
      from_point = Point.new(0,-3,-1)
      to_point = Point.new(3,-3,6)
      result = Vector.new(3,0,7)
      Vector.new(from_point, to_point).should == result
    end

    describe "Arithmetic:" do
      before(:each) do
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

    it "should calculate angle to another vector" do
      v1 = Vector.new(2, 0, 0)
      v2 = Vector.new(0, -3, 0)
      v1.angle_between(v2).should == Math::PI / 2

      v4 = Vector.new(2, 0, 0)
      v5 = Vector.new(0, 3, 0)
      v4.angle_between(v5).should == Math::PI / 2

      v7 = Vector.new(2, 0, 0)
      v8 = Vector.new(-2, -2, 0)
      v7.angle_between(v8).should == Math::PI * (3 / 4.0)


      v14 = Vector.new(0, 1, 0)
      v15 = Vector.new(0, -1, 0)
      v14.angle_between(v15).should == Math::PI
    end

    it "should determine if same direction with another vector" do
      v1 = Vector.new(1, 0, 0)
      v2 = Vector.new(1, 1, 0)
      v3 = Vector.new(-1, 0.001, 0)
      v1.same_direction(v2).should be_true
      v1.same_direction(v3).should be_false
    end

    it "should determine if parallel with another vector" do
      pending("not implemented")
    end

    it "should determine if zero vector" do
      pending("not implemented")
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

    describe "Return Types:" do

      it "should return as point" do
        Vector.new(@valid_attributes).to_point.should == Point.new(@valid_attributes)
      end

      it "should return as array" do
        Vector.new(@valid_attributes).to_ary.should == @valid_attributes
      end
    end

    describe "Translation:" do
    end

    describe "Transformation:" do
    end

  end
end
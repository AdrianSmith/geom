require_relative '../spec_helper.rb'
require 'geom/transformation'

module Geom
  describe Transformation do
    before do
      @p1 = Point.new(0,0,0)
      @p2 = Point.new(10,1,1)
      @vx = Vector.new(1,0,0)
      @vy = Vector.new(0,1,0)
      @vz = Vector.new(0,0,1)
      @rcs_1 = RectangularCoordinateSystem.new_from_xvector_and_xyplane(@p1, @vx, @vz)
      @rcs_2 = RectangularCoordinateSystem.new_from_xvector_and_xyplane(@p2, @vx, @vz)
      @rcs_3 = RectangularCoordinateSystem.new_from_xvector_and_xyplane(@p1, @vy, @vz)
    end

    describe "Construction"   do
      it "should create a valid instance from a coordinate systems" do
        transform = Transformation.new(RectangularCoordinateSystem.new)
        transform.identity?.should be_true
      end
    end

    describe "Type" do
      it "should determine if transformation involves translation" do
        transform = Transformation.new(@rcs_2)
        transform.translation?.should be_true
        transform.rotation?.should be_false
        transform.scaling?.should be_false
        transform.type.should == 2
      end

      it "should determine if transformation involved rotation" do
        transform = Transformation.new(@rcs_3)
        transform.translation?.should be_false
        transform.rotation?.should be_true
        transform.scaling?.should be_false
        transform.type.should == 1
      end
    end

    describe "Return Types" do
      it "should print matrix formatted string" do
        transform = Transformation.new(@rcs_1)
        transform.to_s(true).should be
      end

      it "should calculate translation vector" do
        transform = Transformation.new(@rcs_2)
        transform.translation_vector.should == Vector.new(10.0, 1.0, 1.0)
      end
    end

    describe "Rotation Matrix" do
      it "should extract sub-matrix" do
        transform = Transformation.new(@rcs_2)
        transform.rotation_submatrix.should == Matrix.diagonal(1,1,1)
      end

      it "should determine if diagonal when only non-zeros on the diagonal" do
        transform = Transformation.new(@rcs_2)
        transform.rotation_submatrix_diagonal?.should be_true
      end
    end
  end
end
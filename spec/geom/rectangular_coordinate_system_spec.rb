require_relative '../spec_helper.rb'
require 'geom/rectangular_coordinate_system'

module Geom
  describe RectangularCoordinateSystem do

    describe "Construction" do
      before do
        @origin  = Point.new(0,0,0)
        @ivector = Vector.new(1,0,0)
        @jvector = Vector.new(0,1,0)
        @kvector = Vector.new(0,0,1)
        @rcs = RectangularCoordinateSystem.new
      end

      it "should construct a RCS using x-vector and xy-plane normal vector" do
        RectangularCoordinateSystem.new_from_xvector_and_xyplane(@origin, @ivector, @kvector).should == @rcs
      end

      it "should construct a RCS using y-vector and yz-plane normal vector" do
        RectangularCoordinateSystem.new_from_yvector_and_yzplane(@origin, @jvector, @ivector).should == @rcs
      end

      it "should construct a RCS using z-vector and zx-plane normal vector" do
        RectangularCoordinateSystem.new_from_zvector_and_zxplane(@origin, @kvector, @jvector).should == @rcs
      end
    end

    describe "Return types" do
      it "should return a summary string" do
        RectangularCoordinateSystem.new.to_s.should == "RCS[Point(0.000,0.000,0.000) X-Vector(1.000,0.000,0.000) Y-Vector(0.000,1.000,0.000) Z-Vector(0.000,0.000,1.000)]"
      end

      it "should calculate a 4x4 transformation matrix" do
        RectangularCoordinateSystem.new.transformation_matrix.should ==  Matrix[
          [1, 0, 0, 0],
          [0, 1, 0, 0],
          [0, 0, 1, 0],
          [0, 0, 0, 1]
        ]
      end
    end

  end
end

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
        expect(transform.identity?).to be_truthy
      end
    end

    describe "Type" do
      it "should determine if transformation involves translation" do
        transform = Transformation.new(@rcs_2)
        expect(transform.translation?).to be_truthy
        expect(transform.rotation?).to be_falsey
        expect(transform.scaling?).to be_falsey
        expect(transform.type).to eq(1)
      end

      it "should determine if transformation involved rotation" do
        transform = Transformation.new(@rcs_3)
        expect(transform.translation?).to be_falsey
        expect(transform.rotation?).to be_truthy
        expect(transform.scaling?).to be_falsey
        expect(transform.type).to eq(2)
      end
    end

    describe "Return Types" do
      it "should print matrix formatted string" do
        expect(Transformation.new(@rcs_1).to_s(true)).to be
      end

      it "should create a description" do
        expect(Transformation.new(@rcs_2).type_description).to eq("Type 1 Translation")
        expect(Transformation.new(@rcs_3).type_description).to eq("Type 2 Rotation")
      end

      it "should calculate translation vector" do
        expect(Transformation.new(@rcs_2).translation_vector).to eq(Vector.new(10.0, 1.0, 1.0))
      end
    end

    describe "Rotation Matrix" do
      it "should extract sub-matrix" do
        transform = Transformation.new(@rcs_2)
        expect(transform.rotation_submatrix).to eq(Matrix.diagonal(1,1,1))
      end

      it "should determine if diagonal when only non-zeros on the diagonal" do
        transform = Transformation.new(@rcs_2)
        expect(transform.rotation_submatrix_diagonal?).to be_truthy
      end
    end
  end
end
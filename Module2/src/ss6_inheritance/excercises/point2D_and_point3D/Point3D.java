package ss6_inheritance.excercises.point2D_and_point3D;

import java.util.Arrays;

public class Point3D extends Point2D {
    private float z;
    public Point3D(){

    }
    public Point3D(float x, float y, float z){
        super(x, y);
        this.z=z;
    }
    public float getZ(){
        return this.z;
    }
    public void setZ(float z){
        this.z=z;
    }
    public void setXYZ(float x, float y, float z){
        this.setX(x);
        this.setY(y);
        this.z = z;
    }
    public float[] getXYZ(){
        return new float[]{this.getX(),this.getY(),this.z};
    }

    @Override
    public String toString() {
        return "Point3D("
                + getX()
                +","
                +getY()
                +","
                +z
                +")";
    }
}

package ss7_abstract_and_interface.excersice.system_of_geometric_objects;

public class Rectangle extends Shape {
    private double width =1;
    private double length =1;
    public Rectangle(){

    }
    public Rectangle(double width,double length){
        this.width=width;
        this.length=length;
    }
    public Rectangle(double width,double length,String color, boolean filled){
        super(color, filled);
        this.width=width;
        this.length=length;
    }
    public double getWidth(){
        return this.width;
    }
    public void setWidth(double width){
        this.width=width;
    }
    public double getLength(){
        return this.length;
    }
    public void setLength(double length){
        this.length=length;
    }
    public void getArea(){
        System.out.println(this.getLength()*this.getWidth());
    }
    public double getPerimeter(){
        return (this.length + this.width)*2;
    }
    public String toString(){
        return "A rectangle with width = "
                + getWidth()
                + " and length = "
                + getLength()
                + " ,which is a subclass of "
                +super.toString();
    }
}

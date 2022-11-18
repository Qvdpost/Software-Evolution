// package myjavacode;
package test;
import main.Calculate;

public class Test {


    private  Integer mult(Integer x, Integer y) {
        return x * y;
    }


    public void main(String
    [] args) {
        System.out.println("Starting main");
        Calculate x = new Calculate();
        Integer z = x.minus(10, 4);
        // System.out.println("Z: " + z.toString());
        // Integer test = this.mult(5,6);
        // /* */
        //  /* */System.out.println("Test: " + test.toString());

        // for(Integer iep = 0; iep < 10; iep++) { /* */
        //     System.out.println(iep.toString());
        //     for(Integer j = 0; j < 10; j++) {
        //         System.out.println(iep.toString());
        //     }
        // }

    }
}
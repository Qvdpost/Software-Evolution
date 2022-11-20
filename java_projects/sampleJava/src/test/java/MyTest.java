// package myjavacode;
package test;
import main.Calculate;
import org.junit.*;
import org.junit.Test;
import static org.junit.Assert.*;



public class MyTest {

    public MyTest(){}

    private  Integer multo(Integer x, Integer y) {
        return x * y;
    }

    @Test
    public void tester() {
        System.out.println("Starting main");
        Calculate x = new Calculate();
        Integer a = 10;
        Integer b = 4;
        Integer c = 6;
        Integer d = 40;
        Integer z = x.minus(a, b);
        Integer zz = this.multo(a, b);

        assertEquals(z,c);
        assertEquals(zz,d);

    }
}
// package myjavacode;
package test;
import main.Calculate;
import org.junit.*;
import org.junit.Test;
import static org.junit.Assert.*;



public class MyTest {

    public MyTest(){}

    private  Integer mult(Integer x, Integer y) {
        return x * y;
    }

    @Test
    public void tester() {
        System.out.println("Starting main");
        Calculate x = new Calculate();
        Integer a = 10;
        Integer b = 4;
        Integer c = 6;
        Integer z = x.minus(a, b);
        assertEquals(z,c);
    }
}
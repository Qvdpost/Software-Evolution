package main;


public class CalculateTwo {

    public static void main(String [] args) {
        System.out.println(false||true);

    }

    CalculateTwo(){
        System.out.println("x");
    }

    public Integer plus(Integer x, Integer y) {
        System.out.println("z");
        System.out.println("z");
        System.out.println("z");
        System.out.println("z");

        for(Integer iep = 0; iep < 10; iep++) { /* */
            System.out.println(iep.toString());
            for(Integer j = 0; j < 10; j++) { /* */
                System.out.println(j.toString());
                System.out.println(j.toString());
            }
        }
        return  x - y;
    }

}
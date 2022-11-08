// package myjavacode;

public class TestIng {

    public static Integer add(Integer x, Integer y) {
        return x + y;
    }

    public static void main(String
    [] args) {
        System.out.println("Starting main");

        Integer test = add(5,6);
        /* */
         /* */System.out.println("Test: " + test.toString());

        for(Integer iep = 0; iep < 10; iep++) { /* */
            System.out.println(iep.toString());
            for(Integer j = 0; j < 10; j++) {
                System.out.println(iep.toString());
            }
        }

    }
}
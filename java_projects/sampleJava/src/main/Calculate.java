package main;

public class Calculate {
    public Calculate() {
    }

    public Integer minus(Integer x, Integer y) {
        return x - y;
    }

    public Integer add(Integer x, Integer y) {
        return x + y;
    }

    public static Integer mult(Integer x, Integer y) {
        return x * y;
    }

    public static Integer add2(Integer x, Integer y) {
        return x + y;
    }

    /*
     * public static Integer add3(Integer x, Integer y) {
     * return x + y;
     * }
     */
    public void main(String[] args) {
        System.out.println("Starting main");

        Integer test = 10;
        /* */System.out.println("Test: " + test.toString());

        for (Integer iep = 0; iep < 10; iep++) { /* */
            System.out.println(iep.toString());
            for (Integer j = 0; j < 10; j++) {
                System.out.println(iep.toString());
            }
        }

    }
}
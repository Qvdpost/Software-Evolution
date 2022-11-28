class Booleans {
  
  public static void main(String[] args) {
    System.out.println(true && (false && true) && true && false);
    System.out.println(true && (false && true) ? (false || true) : false);
    System.out.println(false||true);
    System.out.println((true && (true && true)) ? (false || true) : false);
    System.out.println(true && (false && true) ? null : true ? null : null);
  }
}
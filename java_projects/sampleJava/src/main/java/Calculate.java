package main;


public class Calculate {

    Calculate(){
        new Calculate();
    }

    public static void main(String [] args) {
        System.out.println(false||true);
    }

    public Integer add(Integer lhs, Integer rhs) {
        return lhs + rhs;
    }

    public Integer type1(Integer x, Integer y) {
        System.out.println("z");
        System.out.println("y");
        System.out.println("x");

        for(Integer iep = 0; iep < 10; iep++) { /* */
            System.out.println(iep.toString());
            for(Integer j = 0; j < 10; j++) { /* */
                System.out.println(j.toString());
                System.out.println(j.toString());
            }
        }
        return  x - y;
    }

    public Integer type2(Integer x, Integer y) {

        System.out.println("hello");
        System.out.println("42");
        System.out.println("world");

        Integer World = 42;

        for(Integer i = 0; i < 10; i++) { /* */
            System.out.println(i.toString());
            for(Integer f = 0; f < 10; f++) { /* */
                System.out.println(f.toString());
                System.out.println(f.toString());
            }
        }
        return  x - y;
    }

    public Double type3(Double x, Double y) {
        Double result = 0.0;
        result = x % y;
        System.out.println(result);

        if (result > 0) {
            result *= 2;
        } else {
            result *= 3;
        }

        return  result - y;
    }

    public Double type3PartTwo(Double x, Double y) {
        Double result = 0.0;
        result = x % y;
        System.out.println(result);

        if (result > 0) {
            result *= 2;
        } else {
            result *= 3;
        }


        for(Integer f = 0; f < 10; f++) { /* */
            result += 1;
        }

        Integer test = this.add(10, 3);

        return  result - y;
    }

	public void testOrderBy_varchar_GroupBy() throws Exception{
		init();
		Connection con = AllTests.getConnection();
		Statement st = con.createStatement();
		ResultSet rs;
		String oldValue;

		rs = st.executeQuery("SELECT first(v) cc FROM " + table1 + " Group By i ORDER  by first(V)");

		assertTrue( rs.next() );

		oldValue = rs.getString("cc");
		assertNull(oldValue);
		assertTrue( rs.next() );
		oldValue = rs.getString("cc");

		int count = 1;
		while(rs.next()){
			assertTrue( oldValue.compareTo( rs.getString("cc") ) < 0 );
			oldValue = rs.getString("cc");
			count++;
		}
		assertEquals( valueCount, count );
	}
}
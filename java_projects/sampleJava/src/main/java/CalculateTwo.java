package main;

public class CalculateTwo {

    public static void main(String[] args) {
        System.out.println(false || true);

    }

    CalculateTwo() {
        new CalculateTwo();
    }

    public Integer add(Integer lhs, Integer rhs) {
        return lhs + rhs;
    }

    public Double type1Clone(Double x, Double y) {
        System.out.println("z");
        System.out.println("y");
        System.out.println("x");

        for (Integer iep = 0; iep < 10; iep++) { /* */
            System.out.println(iep.toString());
            for (Integer j = 0; j < 10; j++) { /* */
                System.out.println(j.toString());
                System.out.println(j.toString());
            }
        }
        return x - y;
    }

    public Integer type1OrphanClone(Integer x, Integer y) {
        for (Integer iep = 0; iep < 10; iep++) { /* */
            iep += 5;
            iep += 10;
            iep += 13;
        }
    }

    public Integer type1OrphanedClone(Integer x, Integer y) {
        System.out.println("z");
        System.out.println("y");
        System.out.println("x");

        for (Integer iep = 0; iep < 10; iep++) { /* */
            iep += 5;
            iep += 10;
            iep += 13;
        }
        return x * y;
    }

    public Integer type2Clone(Integer x, Integer y) {

        System.out.println("This");
        System.out.println("is ");
        System.out.println("a type2Clone");

        Integer Whale = 96;

        for (Integer iterator = 0; iterator < 10; iterator++) { /* */
            System.out.println(iterator.toString());
            for (Integer j = 0; j < 10; j++) { /* */
                System.out.println(j.toString());
                System.out.println(j.toString());
            }
        }
        return x - y;
    }

    public Double type3Clone(Double x, Double y) {
        Double result = 0.0;

        System.out.println(x);
        result = x % y;
        System.out.println(result);

        if (result > 0) {
            result *= 2;
        } else {
            result *= 3;
        }

        System.out.println(result);

        return result - y;
    }

    public Double type3ClonePartTwo(Double x, Double y) {
        Double result = 0.0;

        System.out.println(x);
        result = x % y;
        System.out.println(result);

        if (result > 0) {
            result *= 2;
        } else {
            result *= 3;
        }
        return result - y;
    }

	public void testOrderBy_nvarchar() throws Exception{
		init();
		Connection con = AllTests.getConnection();
		Statement st = con.createStatement();
		ResultSet rs;
		String oldValue;

		rs = st.executeQuery("SELECT * FROM " + table1 + " ORDER  by nv");

		assertTrue( rs.next() );

		oldValue = rs.getString("nv");
		assertNull(oldValue);
		assertTrue( rs.next() );
		oldValue = rs.getString("nv");

		int count = 1;
		while(rs.next()){
			assertTrue( String.CASE_INSENSITIVE_ORDER.compare( oldValue, rs.getString("nv") ) <= 0 );
			oldValue = rs.getString("nv");
			count++;
		}
		assertEquals( valueCount, count );
	}


}
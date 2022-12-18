package main;

public class CalculateThree {

    public static void main(String[] args) {
        System.out.println(false || true);

    }

    CalculateThree() {
        new CalculateThree();
    }
	public void testOrderBy_varchar() throws Exception{
		init();
		Connection con = AllTests.getConnection();
		Statement st = con.createStatement();
		ResultSet rs;
		String oldValue;

		rs = st.executeQuery("SELECT * FROM " + table1 + " ORDER  by v");

		assertTrue( rs.next() );

		oldValue = rs.getString("v");
		assertNull(oldValue);
		assertTrue( rs.next() );
		oldValue = rs.getString("v");

		int count = 1;
		while(rs.next()){
			String newValue = rs.getString("v");
			assertTrue( oldValue + "<" + newValue, oldValue.compareTo( newValue ) < 0 );
			oldValue = newValue;
			count++;
		}
		assertEquals( valueCount, count );
	}

}
Edge

EdgeTest := UnitTest clone do(

	testSetAttribute := method(
    nod := Edge clone
    nod setAttribute("attr", 42)
		assertEquals(nod attributeAt("attr"), 
                 Edge  clone do(attr atPut("attr", 42)) attributeAt("attr"))
	)
  
)

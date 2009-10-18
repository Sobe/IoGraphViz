Edge

# Tests for Edge proto
EdgeTest := UnitTest clone do(

	testSetAttribute := method(
    edg := Edge clone with(Node clone, Node clone, nil)
    edg setAttribute("attr", 42)
		assertEquals(edg attributeAt("attr"), 42)
	)
  
)

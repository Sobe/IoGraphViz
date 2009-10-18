Node

# Tests for Node proto
NodeTest := UnitTest clone do(

	testSetAttribute := method(
    nod := Node clone with("node1")
    nod setAttribute("attr", 42)
		assertEquals(nod attributeAt("attr"), 42)
	)
  
)

Node

NodeTest := UnitTest clone do(

	testSetAttribute := method(
    nod := Node clone
    nod setAttribute("attr", 42)
		assertEquals(nod attributeAt("attr"), 
                 Node clone do(attrNode atPut("attr", 42)) attributeAt("attr"))
	)
  
)

IoGraphViz

IoGraphVizTest := UnitTest clone do(
  
  verbose

	testAddNode := method(
    nodOpt := Map clone do(atPut("regular", 1))
    #edgOpt := Map clone do(atPut("len", 42))
  
    igv := IoGraphViz clone
    igv addNode("node1", nodOpt)
    igv addNode("node2", nodOpt)
  
		assertEquals(igv nodes size, 2)
    assertEquals(igv nodes at("node1") attributeAt("regular"), 1)
	)
  
)

IoGraphViz

# Tests for IoGraphViz proto
IoGraphVizTest := UnitTest clone do(
  
  verbose

	testAddNode := method(
    nodOpt := Map clone do(atPut("regular", 1))
  
    igv := IoGraphViz clone with("igv")
    igv addNode("node1", nodOpt)
    igv addNode("node2", nodOpt)
  
		assertEquals(igv nodes size, 2)
    assertEquals(igv nodes at("node1") attributeAt("regular"), 1)
	)
  
)

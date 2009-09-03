IoGraphViz

IoGraphVizTest := UnitTest clone do(

	testAddNode := method(
    nodOpt := Map clone do(atPut("regular", 1))
    edgOpt := Map clone do(atPut("len", 42))
  
    igv := IoGraphViz clone
    igv addNode("node1", nodOpt)
    igv addNode("node2", nodOpt)
    
    writeln("SIZE: ", igv nodes size)
  
		assertTrue(igv nodes size == 2)
	)
  
)

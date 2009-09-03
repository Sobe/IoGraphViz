Node
Edge

# 
IoGraphViz := Object clone do(
  
  name := "Graph"
  fileName := "out"
  format := "canon"
  prog := "dot"
  path := nil
  
  parentGraph := nil
  graphType := "digraph"
  
  elements := list()
  
  # TODO see if these containers are OK
  nodes := Map clone
  edges := list()
  graphs := Map clone
  # Ruby version:
  #~ @hoNodes  = Hash::new()
  #~ @loEdges  = Array::new()
  #~ @hoGraphs = Hash::new()
    
    
  # TODO handle that
  #~ @node  = GraphViz::Attrs::new( self, "node",  NODESATTRS  )
  #~ @edge  = GraphViz::Attrs::new( self, "edge",  EDGESATTRS  )
  #~ @graph = GraphViz::Attrs::new( self, "graph", GRAPHSATTRS )
  
  
  # Add a new node to self
  # Return added node
  addNode := method(nodeName, nOptions,
    newNode := Node clone with(name = nodeName, parentGraph = self)
    nOptions ifNonNil(
      nOptions foreach(k, v, 
        newNode setAttribute(k, v)
      )
    )
    
    nodes atPut(newNode name, newNode)
    elements append(newNode)
    newNode
  )
  
  # Add a new edge to self
  # nSource and nTarget can be single nodes or nodes lists
  # return added edge
  addEdge := method(nSource, nTarget, eOptions,
    
    addedEdges := list()
    
    if(nSource isKindOf(List),
      nSource foreach(nod, 
        addedEdges append(addEdge(nod, nTarget, eOptions))
      )
      
    ,
      if(nTarget isKindOf(List),
        nTarget foreach(nod,
          addedEdges append(addEdge(nSource, nod, eOptions))
        )
        
      ,
        newEdge := Edge clone with(
          nodeFrom = nSource,
          nodeTo = nTarget,
          parentGraph = self
        )
        eOptions ifNonNil(
          eOptions foreach(k, v, 
            newEdge setAttribute(k, v)
          )
        )
        addedEdges append(newEdge)
        edges append(newEdge)
        elements append(newEdge)
        
      )
    )
    
    addedEdges
  )
  
  nodesCount := method(nodes size)
  edgesCount := method(edges size)
  
  
  
  

)

#writeln(IoGraphViz edges)

# DOC: docSlot
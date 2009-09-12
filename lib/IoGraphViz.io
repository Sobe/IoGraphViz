Node
Edge
Constants

# 
IoGraphViz := Object clone do(
  
  name := "G"
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
    newNode := Node clone with(nodeName, self name)
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
          nSource,
          nTarget,
          self name
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
    
    return(addedEdges)
  )
  
  nodesCount := method(nodes size)
  
  edgesCount := method(edges size)
  
  # Generate the graph
  #
  # Options:
  #   'output'  => output format
  #   'file'    => output file name
  #   'use'     => GraphViz program to use
  #   'path'    => program path
  #
  output := method(options,
    dotScript := ""
    lastType := nil
    separator := ""
    data := ""
    
    elements foreach(elt,
      if((lastType isNil) or (lastType != elt type),
        
        if(data size > 0,
          lastType switch(
            # TODO case "graph"
            "Node",
              dotScript = dotScript .. "  node [" .. data .. "];\n",
            "Edge",
              dotScript = dotScript .. "  edge [" .. data .. "];\n"
          )
        )
        
      )
      
      lastType = elt type
      
      # TODO if necessary: check value is not nil (raise error)
      
      elt type switch(
        # TODO attr cases
        "Node",
          elt type println
          dotScript = dotScript .. "  " .. elt outputNode() .. "\n"
        "Edge",
          elt type println
          dotScript = dotScript .. "  " .. elt outputEdge(graphType) .. "\n",
        # ELSE
          Exception raise("Unknow element type")
      )
    )
    
    if(data size > 0,
      # TODO switch *_attr
      nil
    )
    dotScript = dotScript .. "}"
    
    if(parentGraph isNil == false,
      dotScript = "subgraph " .. self name .. " {\n" .. dotScript
      #return(dotScript) #=> plain B$
      dotScript
    ,
      if(options isNil == false,
        options foreach(k, v,
          k switch(
            "output",
              if(Constants Formats contains(v) == false,
                Exception raise("Output format " .. v .. " is invalid")
              )
              format = v,
            "file",
              fileName = v,
            "use",
              if(Programs contains(v) == false,
                Exception raise("Can't use '" .. v .. "'")
              )
              prog = v,
            "path",
              path = v,
            # DEFAULT
              Exception raise("Option '" .. v .. "' unknow" )
          )
        )
      )
    )
    
    dotScript = graphType .. " " .. self name .. " {\n" .. dotScript
    
    if(self format != "none",
      # Save script and send it to dot
      #t := File temporaryFile openForUpdating("./temp.dot")
      t := File openForUpdating("./temp.dot")
      t write(dotScript)
      
      # TODO implements findExecutable()
      cmd := "\"C:/Program Files/Graphviz2.18/Bin/dot\""
      
      phyl := ""
      phyl = if(fileName isNil == false, "-o " .. fileName)
      xCmd := cmd .. " -T" .. format .. " " .. phyl .. " " .. t path
      System system(xCmd) println
      
      
      # Clean file
      t close
    ,
      dotScript print
    )
  )

)

#writeln(IoGraphViz edges)

# DOC: docSlot
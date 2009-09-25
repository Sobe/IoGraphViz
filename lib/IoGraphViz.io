# Some kind of big license should be here

#
# TODO Comment
#
IoGraphViz := Object clone do(
  
  # Required protos and files
  Node
  Edge
  Constants
  doRelativeFile("attr.io")
  
  graphName := "G"
  fileName := "out"
  format := "canon"
  prog := "dot"
  path := nil
  
  parentGraph := nil
  graphType := "digraph"
  
  
  # TODO see if these containers are OK
  nodes := nil
  edges := nil
  graphs := nil

  # Ruby version:
  #~ @hoNodes  = Hash::new()
  #~ @loEdges  = Array::new()
  #~ @hoGraphs = Hash::new()
    
  #~ @node  = GraphViz::Attrs::new( self, "node",  NODESATTRS  )
  #~ @edge  = GraphViz::Attrs::new( self, "edge",  EDGESATTRS  )
  #~ @graph = GraphViz::Attrs::new( self, "graph", GRAPHSATTRS )
  attrGraph := nil
  attrNode := nil
  attrEdge := nil
  
  with := method(name,
    self graphName = name
    self attrGraph = GraphAttr clone
    self attrNode = NodeAttr clone
    self attrEdge = EdgeAttr clone
    self nodes := Map clone
    self edges := list()
    self graphs := Map clone
    return self
  )
  
  #
  # Accessors for graphes attributes
  #
  setAttribute := method(attribute, value,
    self attrGraph atPut(attribute, value)
  )
  attributeAt := method(attribute,
    self attrGraph at(attribute)
  )
  
  #
  # Accessors for nodes attributes
  #
  setNodeAttr := method(attribute, value,
    self attrNode atPut(attribute, value)
  )
  nodeAttrAt := method(attribute,
    self attrNode at(attribute)
  )

  #
  # Accessors for edges attributes
  #
  setEdgeAttr:= method(attribute, value,
    self attrEdge atPut(attribute, value)
  )
  edgeAttrAt := method(attribute,
    self attrEdge at(attribute)
  )
  
  
  #
  # Add a new named node to self
  #
  # return added node
  addNode := method(nodeName, nOptions,
    newNode := Node clone with(nodeName, self graphName)
    nOptions ifNonNil(
      nOptions foreach(k, v, 
        newNode setAttribute(k, v)
      )
    )
    
    self nodes atPut(newNode name, newNode)
    newNode
  )
  
  # Add a new edge to self
  #
  # nSource can be a single node or a nodes list
  # nTarget can be a single node or a nodes list
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
          self graphName
        )
        eOptions ifNonNil(
          eOptions foreach(k, v, 
            newEdge setAttribute(k, v)
          )
        )
        addedEdges append(newEdge)
        self edges append(newEdge)
        
      )
    )
    
    return addedEdges
  )
  
  #
  # Add a new Graph to current one
  #
  # graphName   => graph name
  # gOptions    => GraphViz option for this graph
  #
  addGraph := method(gName, gOptions,
    newGraph := IoGraphViz clone with(gName)
    newGraph parentGraph = self
    self graphs atPut(gName, newGraph)
    
    gOptions ?foreach(k, v,
      newGraph setAttribute(k, v)
    )
    
    return newGraph
  )
  
  #
  # Number of nodes
  #
  nodesCount := method(self nodes size)
  
  #
  # Number of edges
  #
  edgesCount := method(self edges size)
  
  #
  # Number of subgraphs
  #
  graphsCount := method(self graphs size)
  
  #
  # Generate the graph
  #
  # Options:
  #   'output'  => output format
  #   'file'    => output file name
  #   'use'     => GraphViz program to use
  #   'path'    => program path
  #
  output := method(options,
    dotScript := "" asMutable
    
    # Open graph (or subgraph)
    if(self parentGraph isNil,
      dotScript appendSeq(graphType .. " " .. self graphName .. " {\n")
    ,
      dotScript appendSeq("subgraph " .. self graphName .. " {\n")
    )
    
    # Write graph attr
    self attrGraph foreach(att, val,
      dotScript appendSeq("  #{att} = \"#{val}\";\n" interpolate)
    )
    
    # Write node attr
    dotScript appendSeq("  node [")
    sep := ""
    self attrNode foreach(att, val,
      dotScript appendSeq("#{sep}#{att} = \"#{val}\"" interpolate)
      sep = ", "
    )
    dotScript appendSeq("];\n")
    
    # Write edge attr
    dotScript appendSeq("  edge [")
    sep := ""
    self attrEdge foreach(att, val,
      dotScript appendSeq("#{sep}#{att} = \"#{val}\"" interpolate)
      sep = ", "
    )
    dotScript appendSeq("];\n")
    
    dotScript appendSeq("\n")
    
    # Write graphs
    self graphs foreach(nam, grph,
      dotScript appendSeq(grph output(nil))
      dotScript appendSeq("\n")
    )
    
    # Write nodes
    # TODO use Node outpoutNode
    self nodes foreach(nam, nod,
      dotScript appendSeq("  " .. nam)
      if(nod attrNode size > 0, dotScript appendSeq(" ["))
      sep := ""
      nod attrNode foreach(att, val,
        dotScript appendSeq("#{sep}#{att} = \"#{val}\"" interpolate)
        sep = ", "
      )
      if(nod attrNode size > 0, dotScript appendSeq("]"))
      dotScript appendSeq(";\n")
    )
    
    dotScript appendSeq("\n")
    
    # Write edges
    self edges foreach(edg,
      dotScript appendSeq("  " .. edg outputEdge(graphType) .. "\n")
    )
    
    
    # Close graph
    dotScript appendSeq("}")
    
    if(self parentGraph isNil == false,
      # Case subgraph
      return(dotScript)
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
  
    if(format != "none",
      # Save script and send it to dot
      t := File openForUpdating("./temp.dot") # TODO TemporaryFile
      #t remove
      #t := File openForUpdating("./temp.dot")
      t write(dotScript)
      # TODO change this when Temporary file
      t close
      
      # TODO implements findExecutable() OR use a config file (easier ?)
      cmd := "\"C:/Program Files/Graphviz2.18/Bin/dot\""
      
      phyl := ""
      phyl = if(fileName isNil == false, "-o " .. fileName)
      xCmd := cmd .. " -T" .. format .. " " .. phyl .. " " .. t path
      System system(xCmd) #println
      
      
      # Clean file
      #t close
    ,
      dotScript print
    )
  )

)
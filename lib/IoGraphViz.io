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
  
  elements := list()
  
  # TODO see if these containers are OK
  nodes := Map clone
  edges := list()
  graphs := Map clone
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
    graphName = name
    attrGraph = GraphAttr clone
    attrNode = NodeAttr clone
    attrEdge = EdgeAttr clone
    self
  )
  
  #
  # Accessors for graphes attributes
  #
  setAttribute := method(attribute, value,
    attrGraph atPut(attribute, value)
    elements append(GraphAttr clone with(attribute, value))
  )
  attributeAt := method(attribute,
    attrGraph at(attribute)
  )
  
  #
  # Accessors for nodes attributes
  #
  setNodeAttr := method(attribute, value,
    attrNode atPut(attribute, value)
    elements append(NodeAttr clone with(attribute, value))
  )
  nodeAttrAt := method(attribute,
    attrNode at(attribute)
  )

  #
  # Accessors for edges attributes
  #
  setEdgeAttr:= method(attribute, value,
    attrEdge atPut(attribute, value)
    elements append(EdgeAttr clone with(attribute, value))
  )
  edgeAttrAt := method(attribute,
    attrEdge at(attribute)
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
    
    nodes atPut(newNode name, newNode)
    elements append(newNode)
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
        edges append(newEdge)
        elements append(newEdge)
        
      )
    )
    
    return(addedEdges)
  )
  
  #
  # Add a new Graph to current one
  #
  # graphName   => graph name
  # gOptions    => GraphViz option for this graph
  #
  addGraph := method(gName, gOptions,
    newGraph := IoGraphViz clone with(gName)
    graphs atPut(gName, newGraph)
    elements append(newGraph)
    
    gOptions foreach(k, v,
      newGraph setAttribute(k, v)
    )
    
    newGraph
  )
  
  #
  # Number of nodes
  #
  nodesCount := method(nodes size)
  
  #
  # Number of edges
  #
  edgesCount := method(edges size)
  
  #
  # Generate the graph
  #
  # Options:
  #   'output'  => output format
  #   'file'    => output file name
  #   'use'     => GraphViz program to use
  #   'path'    => program path
  #
  # NOT FUNCTIONAL
  outputFromRuby := method(options,
    dotScript := "" # TODO asMutable
    lastType := nil
    separator := ""
    data := ""
    
    writeln("attrNode:")
    writeln(attrNode keys)
    writeln("attrEdge:")
    writeln(attrEdge keys)
    writeln("In elements:")
    elements foreach(elt, writeln(elt type))
    
    elements foreach(elt,
      if((lastType isNil) or (lastType != elt type),
        
        if(data size > 0,
          lastType switch(
            "GraphAttr",
              dotScript = dotScript .. "  " .. data .. ";\n"
            "NodeAttr",
              writeln("In 1st NodeAttr:")
              writeln(data)
              dotScript = dotScript .. "  node [" .. data .. "];\n",
            "EdgeAttr",
              writeln("In 1st EdgeAttr:")
              writeln(data)
              dotScript = dotScript .. "  edge [" .. data .. "];\n"
          )
        )
        
        separator = ""
        data = ""
      )
      
      lastType = elt type
      
      # Check element is non nil
      if(elt isNil, Exception raise("Found empty element."))

      elt type switch(
        # TODO Refactor here
        "GraphAttr",
          data = data .. separator .. elt keys at(0) .. " = \"" .. elt at(elt keys at(0)) .. "\""
          separator = "; ",
        "NodeAttr",
          writeln("In 2nd NodeAttr:")
          writeln(data)
          data = data .. separator .. elt keys at(0) .. " = \"" .. elt at(elt keys at(0)) .. "\""
          separator = ", ",
        "EdgeAttr",
          writeln("In 2nd EdgeAttr:")
          writeln(data)
          data = data .. separator .. elt keys at(0) .. " = \"" .. elt at(elt keys at(0)) .. "\""
          separator = ", ",
        "Node",
          dotScript = dotScript .. "  " .. elt outputNode() .. "\n",
        "Edge",
          dotScript = dotScript .. "  " .. elt outputEdge(graphType) .. "\n",
        "IoGraphViz",
          dotScript = dotScript .. "  " .. elt output() .. "\n",
        # ELSE
          Exception raise("Unknow element type: " .. elt type)
      )
    )
    
    if(data size > 0,
      lastType switch(
        "GraphAttr",
          dotScript = dotScript .. "  " .. data .. ";\n",
        "NodeAttr",
          writeln("In 3rd NodeAttr:")
          writeln(data)
          dotScript = dotScript .. "  node [" .. data .. "];\n",
        "EdgeAttr",
          writeln("In 3rd EdgeAttr:")
          writeln(data)
          dotScript = dotScript .. "  edge [" .. data .. "];\n"
      )
    )
    dotScript = dotScript .. "}"
    
    if(parentGraph isNil == false,
      # Case subgraph
      dotScript = "subgraph " .. self graphName .. " {\n" .. dotScript
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
    
    dotScript = graphType .. " " .. self graphName .. " {\n" .. dotScript
    
    if(self format != "none",
      # Save script and send it to dot
      t := File openForUpdating("./temp.dot") # TODO TemporaryFile
      #t remove
      #t := File openForUpdating("./temp.dot")
      t write(dotScript)
      # TODO change this when Temporary file
      t close
      
      # TODO implements findExecutable()
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
  
  #####################################################################################################
  output := method(options,
    dotScript := "" asMutable
    
    # Open graph (or subgraph)
    if(self parentGraph isNil,
      dotScript appendSeq(graphType .. " " .. self graphName .. " {\n")
    ,
      dotScript appendSeq("subgraph " .. self graphName .. " {\n")
    )

    if(attrGraph keys size > 0,
      nil
    )
    
    # Write graph attr
    attrGraph foreach(att, val,
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
    graphs foreach(nam, grph,
      dotScript appendSeq(grph output(options))
    )
    
    # Write nodes
    # TODO use Node outpoutNode
    nodes foreach(nam, nod,
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
    edges foreach(edg,
      dotScript appendSeq("  " .. edg outputEdge(graphType) .. "\n")
    )
    
    
    # Close graph
    dotScript appendSeq("}")
    
    if(parentGraph isNil == false,
      # Case subgraph
      dotScript = "subgraph " .. self graphName .. " {\n" .. dotScript
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
      
      # TODO implements findExecutable()
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
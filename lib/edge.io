doRelativeFile("attr.io")

Edge := Object clone do(
  nodeFrom := nil
  nodeTo := nil
  attrEdge := EdgeAttr clone
  parentGraph := nil
  
  setAttribute := method(attribute, value,
    attrEdge atPut(attribute, value)
  )
  
  attributeAt := method(attribute,
    attrEdge at(attribute)
  )
  
  with := method(from, to, parent,
    nodeFrom = from
    nodeTo = to
    parentGraph = parent
    self
  )
  
  outputEdge := method(graphType,
    link := " -> "
    if(graphType == "graph", link = " -- ")
    
    out := nodeFrom name .. link .. nodeTo name
    attr := ""
    separator := ""
    attrEdge foreach(k, v,
      attr = attr .. separator .. k .. " = \"" .. v .. "\""
      separator = ", "
    )
    if(attr size > 0, 
      out = out .. " [" .. attr .. "]"
    )
    out = out .. ";"
    out
  )
)
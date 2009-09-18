doRelativeFile("attr.io")

Node := Object clone do(
  name := nil
  # GV attributes
  parentGraph := nil
  attrNode := nil 
  
  setAttribute := method(attribute, value,
    attrNode atPut(attribute, value)
  )
  
  attributeAt := method(attribute,
    attrNode at(attribute)
  )
  
  #~ << := method(aNode,
    #~ if(aNode isKindOf(List),
      #~ aNode foreach(nod,
        #~ self <<(nod)
      #~ )
    #~ ,
      #~ # TODO check if parentGraphs are the same one
      #~ aNode parentGraph addEdge(self, aNode)
    #~ )
  #~ )
  
  #
  # Initialize main attributes
  #
  # nam     =>  Node name
  # parent  =>  Parent graph
  #
  with := method(nam, parent,
    name = nam
    parentGraph = parent
    attrNode = NodeAttr clone
    self
  )
  
  
  
  outputNode := method(
    out := "" .. name
    attr := ""
    separator := ""
    attrNode foreach(k, v,
      if(k == "html",
        attr = attr .. separator .. "label = <" .. v .. ">"
      ,
        attr = attr .. separator .. k .. " = \"" .. v .. "\""
      )
      separator = ", "
    )
    if(attr size > 0,
      out = out .. " [" .. attr .. "]"
    )
    out = out .. ";"
  )
  
)
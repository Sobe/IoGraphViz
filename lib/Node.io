Node := Object clone do(
  name := ""
  attrNode := Map clone
  parentGraph := nil
  
  setAttribute := method(attribute, value,
    attrNode atPut(attribute, value)
  )
  
  attributeAt := method(attribute,
    attrNode at(attribute)
  )
  
  with := method(nam, parent,
    name = nam
    parentGraph = parent
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
Node := Object clone do(
  name := ""
  attr := Map clone
  parentGraph := nil
  
  setAttribute := method(attribute, value,
    attr atPut(attribute, value)
  )
  
  attributeAt := method(attribute,
    attr at(attribute)
  )
  
  with := method(nam, parent,
    name = nam
    parentGraph = parent
    self
  )
  
)
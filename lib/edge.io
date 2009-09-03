Edge := Object clone do(
  nodeFrom := nil
  nodeTo := nil
  attr := Map clone
  parentGraph := nil
  
  setAttribute := method(attribute, value,
    attr atPut(attribute, value)
  )
  
  attributeAt := method(attribute,
    attr at(attribute)
  )
  
  with := method(from, to, parent,
    nodeFrom = from
    nodeTo = to
    parentGraph = parent
  )
)
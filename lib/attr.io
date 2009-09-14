ProtoAttr := Map clone do(
  
  name := nil
  
  #
  # Initialization with a key/value couple
  #
  with := method(attr, val,
    atPut(attr, val)
    self
  )
)

NodeAttr := ProtoAttr clone do(name = "node")
EdgeAttr := ProtoAttr clone do(name = "edge")
GraphAttr := ProtoAttr clone do(name = "graph")
IoGraphViz

gv := IoGraphViz clone with("A_Program")

gv setNodeAttr("shape", "ellipse")
gv setNodeAttr("color", "black")

gv setEdgeAttr("color", "black")
gv setEdgeAttr("weight", "1")
gv setEdgeAttr("style", "filled")
gv setEdgeAttr("label", "")

gv setAttribute("size", "4,4")

main := gv addNode("main", Map clone do(atPut("shape", "box")))
parse := gv addNode("parse", nil)
execute := gv addNode("execute", nil)
init := gv addNode("init", nil)
cleanup := gv addNode("cleanup", nil)
makeString := gv addNode("make_string", Map clone do(atPut("label", "make a string")))
printf := gv addNode("printf", nil)
compare := gv addNode("compare", Map clone do(
  atPut("shape", "box")
  atPut("style", "filled")
  atPut("color", ".7 .3 1.0")
))

gv addEdge(main, parse, Map clone do(atPut("weight", "8")))
gv addEdge(parse, execute)
gv addEdge(main, init, Map clone do(atPut("style", "dotted")))
gv addEdge(main, cleanup)
gv addEdge(execute, makeString)
gv addEdge(execute, printf)
gv addEdge(init, makeString)
gv addEdge(main, printf, Map clone do(
  atPut("color", "red")
  atPut("style", "bold")
  atPut("label", "100 times")
))
gv addEdge(execute, compare, Map clone do(atPut("color", "red")))

options := Map clone do(
  atPut("output", "png")
  atPut("file", "sample2.png")
)

gv output(options)
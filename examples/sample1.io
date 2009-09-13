IoGraphViz

"BEGINING OF SAMPLE1" println

gv := IoGraphViz clone with("G")

main := gv addNode("main", nil)
parse := gv addNode("parse", nil)
execute := gv addNode("execute", nil)
init := gv addNode("init", nil)
cleanup := gv addNode("cleanup", nil)
makeString := gv addNode("make_string", nil)
printf := gv addNode("printf", nil)
compare := gv addNode("compare", nil)

gv addEdge(main, parse)
gv addEdge(parse, execute)
gv addEdge(main, init)
gv addEdge(main, cleanup)
gv addEdge(execute, makeString)
gv addEdge(execute, printf)
gv addEdge(init, makeString)
gv addEdge(main, printf)
gv addEdge(execute, compare)

options := Map clone do(
  atPut("output", "png")
  atPut("file", "sample1.png")
)

gv output(options)

"END OF SAMPLE1" print
IoGraphViz

"BEGINING OF SAMPLE1" println

gv := IoGraphViz clone
"bp1" println
n1 := gv addNode("1", nil)
n2 := gv addNode("2", nil)
"bp3" println
gv addEdge(n1, n2)

options := Map clone do(
  atPut("output", "png")
  atPut("file", "sample1.png")
)

"bp4" println

gv output(options)

"END OF SAMPLE1" print
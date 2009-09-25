# Sample based on GraphViz clust.dot example

IoGraphViz

gv := IoGraphViz clone with("G")

clust0 := gv addGraph("cluster_0")
clust0 setAttribute("label", "hello world")
clust0 setAttribute("color", "hotpink")
a := clust0 addNode("a")
b := clust0 addNode("b")
c := clust0 addNode("c")
clust0 addEdge(a, b)
clust0 addEdge(a, c)

clust1 := gv addGraph("cluster_1")
clust1 setAttribute("label", "MSDOT")
clust1 setAttribute("style", "dashed")
clust1 setAttribute("color", "purple")
x := clust1 addNode("x")
y := clust1 addNode("y")
z := clust1 addNode("z")
q := clust1 addNode("q")
clust1 addEdge(x, y)
clust1 addEdge(x, z)
clust1 addEdge(y, z)
clust1 addEdge(y, q)

top := Node clone with("top")
gv addEdge(top, a)
gv addEdge(top, y)
gv addEdge(y, b)

options := Map clone do(
  atPut("output", "png")
  atPut("file", "sample3.png")
)

gv output(options)
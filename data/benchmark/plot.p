# output as png image
set terminal png

# save file to "benchmark.png"
set output "data/benchmark/benchmark100.png"
#set output "data/benchmark/benchmark1000.png"
#set output "data/benchmark/benchmark2000.png"

# graph title
set title "ZMGC ApacheBench Benchmarks -n 100"
#set title "ZMGC ApacheBench Benchmarks -n 1000"
#set title "ZMGC ApacheBench Benchmarks -n 2000"

# nicer aspect ratio for image size
set size 1,0.7

# y-axis grid
set grid y

# x-axis label
set xlabel "request"

# y-axis label
set ylabel "response time (ms)"

# plot data from "home-xxx-x.tsv" using column 9 with smooth sbezier lines

plot "data/benchmark/home-100-1.tsv" using 9 smooth sbezier with lines title "-n 100 -c 1", "data/benchmark/home-100-10.tsv" using 9 smooth sbezier with lines title "-n 100 -c 10", "data/benchmark/home-100-100.tsv" using 9 smooth sbezier with lines title "-n 100 -c 100"

#plot "data/benchmark/home-1000-1.tsv" using 9 smooth sbezier with lines title "-n 1000 -c 1", "data/benchmark/home-1000-10.tsv" using 9 smooth sbezier with lines title "-n 1000 -c 10", "data/benchmark/home-1000-100.tsv" using 9 smooth sbezier with lines title "-n 1000 -c 100"

#plot "data/benchmark/home-2000-1.tsv" using 9 smooth sbezier with lines title "-n 2000 -c 1", "data/benchmark/home-2000-10.tsv" using 9 smooth sbezier with lines title "-n 2000 -c 10", "data/benchmark/home-2000-100.tsv" using 9 smooth sbezier with lines title "-n 2000 -c 100"
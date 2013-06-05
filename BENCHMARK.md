#Benchmark Results

##Test -n 100 -c 1
    ☺  ab -n 100 -c 1 -g data/benchmark/home-100-1.tsv http://localhost:3000/                                                                               ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient).....done


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      1
    Time taken for tests:   13.068 seconds
    Complete requests:      100
    Failed requests:        0
    Write errors:           0
    Total transferred:      2132296 bytes
    HTML transferred:       2088400 bytes
    Requests per second:    7.65 [#/sec] (mean)
    Time per request:       130.681 [ms] (mean)
    Time per request:       130.681 [ms] (mean, across all concurrent requests)
    Transfer rate:          159.34 [Kbytes/sec] received

    Connection Times (ms)
                 min  mean[+/-sd] median   max
    Connect:        0    0   0.1      0       1
    Processing:   101  130  54.2    109     475
    Waiting:      101  130  54.2    109     475
    Total:        102  131  54.2    110     475

    Percentage of the requests served within a certain time (ms)
     50%    110
     66%    121
     75%    127
     80%    133
     90%    203
     95%    234
     98%    323
     99%    475
    100%    475 (longest request)
##Test -n 100 -c 10
    ☺  ab -n 100 -c 10 -g data/benchmark/home-100-10.tsv http://localhost:3000/                                                                       ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient).....done


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      10
    Time taken for tests:   10.927 seconds
    Complete requests:      100
    Failed requests:        0
    Write errors:           0
    Total transferred:      2132238 bytes
    HTML transferred:       2088400 bytes
    Requests per second:    9.15 [#/sec] (mean)
    Time per request:       1092.650 [ms] (mean)
    Time per request:       109.265 [ms] (mean, across all concurrent requests)
    Transfer rate:          190.57 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.1      0       1
    Processing:  1034 1092  51.0   1076    1179
    Waiting:     1034 1092  51.0   1076    1179
    Total:       1035 1092  51.0   1076    1179

    Percentage of the requests served within a certain time (ms)
      50%   1076
      66%   1102
      75%   1144
      80%   1169
      90%   1174
      95%   1176
      98%   1177
      99%   1179
     100%   1179 (longest request)
##Test -n 100 -c 100
    ☺  ab -n 100 -c 100 -g data/benchmark/home-100-100.tsv http://localhost:3000/                                                                     ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient).....done


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      100
    Time taken for tests:   10.906 seconds
    Complete requests:      100
    Failed requests:        0
    Write errors:           0
    Total transferred:      2132276 bytes
    HTML transferred:       2088400 bytes
    Requests per second:    9.17 [#/sec] (mean)
    Time per request:       10905.665 [ms] (mean)
    Time per request:       109.057 [ms] (mean, across all concurrent requests)
    Transfer rate:          190.94 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        1    7   4.1      9      11
    Processing: 10744 10808  48.2  10815   10894
    Waiting:    10743 10808  48.2  10815   10894
    Total:      10754 10815  44.6  10824   10895

    Percentage of the requests served within a certain time (ms)
      50%  10824
      66%  10835
      75%  10848
      80%  10857
      90%  10887
      95%  10890
      98%  10895
      99%  10895
     100%  10895 (longest request)
##Test -n 1000 -c 1
    ☺  ab -n 1000 -c 1 -g data/benchmark/home-1000-1.tsv http://localhost:3000/                                                                       ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient)
    Completed 100 requests
    Completed 200 requests
    Completed 300 requests
    Completed 400 requests
    Completed 500 requests
    Completed 600 requests
    Completed 700 requests
    Completed 800 requests
    Completed 900 requests
    Completed 1000 requests
    Finished 1000 requests


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      1
    Time taken for tests:   114.234 seconds
    Complete requests:      1000
    Failed requests:        0
    Write errors:           0
    Total transferred:      21322512 bytes
    HTML transferred:       20884000 bytes
    Requests per second:    8.75 [#/sec] (mean)
    Time per request:       114.234 [ms] (mean)
    Time per request:       114.234 [ms] (mean, across all concurrent requests)
    Transfer rate:          182.28 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.1      0       2
    Processing:   101  114  34.4    105     485
    Waiting:      100  114  34.4    105     485
    Total:        101  114  34.4    105     485

    Percentage of the requests served within a certain time (ms)
      50%    105
      66%    106
      75%    107
      80%    108
      90%    128
      95%    163
      98%    245
      99%    282
     100%    485 (longest request)
##Test -n 1000 -c 10
    ☺  ab -n 1000 -c 10 -g data/benchmark/home-1000-10.tsv http://localhost:3000/                                                                     ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient)
    Completed 100 requests
    Completed 200 requests
    Completed 300 requests
    Completed 400 requests
    Completed 500 requests
    Completed 600 requests
    Completed 700 requests
    Completed 800 requests
    Completed 900 requests
    Completed 1000 requests
    Finished 1000 requests


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      10
    Time taken for tests:   115.996 seconds
    Complete requests:      1000
    Failed requests:        0
    Write errors:           0
    Total transferred:      21322676 bytes
    HTML transferred:       20884000 bytes
    Requests per second:    8.62 [#/sec] (mean)
    Time per request:       1159.965 [ms] (mean)
    Time per request:       115.996 [ms] (mean, across all concurrent requests)
    Transfer rate:          179.51 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.4      0      10
    Processing:   593 1154 183.4   1119    2253
    Waiting:      592 1154 183.5   1118    2253
    Total:        597 1155 183.4   1119    2253

    Percentage of the requests served within a certain time (ms)
      50%   1119
      66%   1154
      75%   1179
      80%   1199
      90%   1404
      95%   1490
      98%   1646
      99%   1863
     100%   2253 (longest request)
##Test -n 1000 -c 100
    ☺  ab -n 1000 -c 100 -g data/benchmark/home-1000-100.tsv http://localhost:3000/                                                                   ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient)
    Completed 100 requests
    Completed 200 requests
    Completed 300 requests
    Completed 400 requests
    Completed 500 requests
    Completed 600 requests
    Completed 700 requests
    Completed 800 requests
    Completed 900 requests
    Completed 1000 requests
    Finished 1000 requests


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      100
    Time taken for tests:   110.720 seconds
    Complete requests:      1000
    Failed requests:        0
    Write errors:           0
    Total transferred:      21322518 bytes
    HTML transferred:       20884000 bytes
    Requests per second:    9.03 [#/sec] (mean)
    Time per request:       11071.996 [ms] (mean)
    Time per request:       110.720 [ms] (mean, across all concurrent requests)
    Transfer rate:          188.07 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    1   2.6      0      10
    Processing: 10674 11029 186.9  11001   11424
    Waiting:    10674 11029 186.8  11001   11424
    Total:      10683 11030 185.5  11002   11424

    Percentage of the requests served within a certain time (ms)
      50%  11002
      66%  11045
      75%  11092
      80%  11231
      90%  11302
      95%  11415
      98%  11418
      99%  11420
     100%  11424 (longest request)
##Test -n 2000 -c 1
    ☺  ab -n 2000 -c 1 -g data/benchmark/home-2000-1.tsv http://localhost:3000/                                                                       ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient)
    Completed 200 requests
    Completed 400 requests
    Completed 600 requests
    Completed 800 requests
    Completed 1000 requests
    Completed 1200 requests
    Completed 1400 requests
    Completed 1600 requests
    Completed 1800 requests
    Completed 2000 requests
    Finished 2000 requests


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      1
    Time taken for tests:   223.521 seconds
    Complete requests:      2000
    Failed requests:        0
    Write errors:           0
    Total transferred:      42645204 bytes
    HTML transferred:       41768000 bytes
    Requests per second:    8.95 [#/sec] (mean)
    Time per request:       111.760 [ms] (mean)
    Time per request:       111.760 [ms] (mean, across all concurrent requests)
    Transfer rate:          186.32 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.2      0       5
    Processing:   101  112  20.6    105     450
    Waiting:      101  111  20.6    105     450
    Total:        102  112  20.6    106     450

    Percentage of the requests served within a certain time (ms)
      50%    106
      66%    107
      75%    109
      80%    112
      90%    122
      95%    153
      98%    166
      99%    195
     100%    450 (longest request)
##Test -n 2000 -c 10
    ☺  ab -n 2000 -c 10 -g data/benchmark/home-2000-10.tsv http://localhost:3000/                                                                     ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient)
    Completed 200 requests
    Completed 400 requests
    Completed 600 requests
    Completed 800 requests
    Completed 1000 requests
    Completed 1200 requests
    Completed 1400 requests
    Completed 1600 requests
    Completed 1800 requests
    Completed 2000 requests
    Finished 2000 requests


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      10
    Time taken for tests:   220.980 seconds
    Complete requests:      2000
    Failed requests:        0
    Write errors:           0
    Total transferred:      42645452 bytes
    HTML transferred:       41768000 bytes
    Requests per second:    9.05 [#/sec] (mean)
    Time per request:       1104.902 [ms] (mean)
    Time per request:       110.490 [ms] (mean, across all concurrent requests)
    Transfer rate:          188.46 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.2      0       3
    Processing:   327 1103  96.0   1076    1860
    Waiting:      327 1103  96.0   1076    1860
    Total:        328 1103  96.0   1076    1860

    Percentage of the requests served within a certain time (ms)
      50%   1076
      66%   1126
      75%   1150
      80%   1163
      90%   1186
      95%   1243
      98%   1312
      99%   1386
     100%   1860 (longest request)
##Test -n 2000 -c 100
    ☺  ab -n 2000 -c 100 -g data/benchmark/home-2000-100.tsv http://localhost:3000/                                                                   ruby-2.0.0-p195 master a6f469a""
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient)
    Completed 200 requests
    Completed 400 requests
    Completed 600 requests
    Completed 800 requests
    Completed 1000 requests
    Completed 1200 requests
    Completed 1400 requests
    Completed 1600 requests
    Completed 1800 requests
    Completed 2000 requests
    Finished 2000 requests


    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /
    Document Length:        20884 bytes

    Concurrency Level:      100
    Time taken for tests:   227.700 seconds
    Complete requests:      2000
    Failed requests:        0
    Write errors:           0
    Total transferred:      42645450 bytes
    HTML transferred:       41768000 bytes
    Requests per second:    8.78 [#/sec] (mean)
    Time per request:       11385.000 [ms] (mean)
    Time per request:       113.850 [ms] (mean, across all concurrent requests)
    Transfer rate:          182.90 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.8      0       6
    Processing:   707 11352 1065.4  11233   22185
    Waiting:      707 11351 1065.4  11233   22184
    Total:        707 11352 1065.1  11234   22185

    Percentage of the requests served within a certain time (ms)
      50%  11234
      66%  11596
      75%  11676
      80%  11704
      90%  11843
      95%  12022
      98%  15035
      99%  15045
     100%  22185 (longest request)

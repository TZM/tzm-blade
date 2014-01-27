(function mapClient() {
    var personPath = "m 1.4194515,-160.64247 c 33.5874165,0 60.8159465,-25.97005 60.8159465,-58.00952 0,-32.0404 -27.22755,-58.0114 -60.8159465,-58.0114 -33.5883965,0 -60.8159415,25.971 -60.8159415,58.0114 0,32.0404 27.228527,58.00952 60.8159415,58.00952 z m 81.9575765,26.25762 C 70.531608,-146.64352 55.269688,-153.983 0.08110256,-153.983 c -55.19742156,0 -70.08915856,7.96609 -82.28062656,19.59815 -12.197359,11.62926 -8.081167,135.7024419 -8.081167,135.7024419 L -63.292733,-59.848397 -46.325227,122.37766 2.6291765,29.116913 48.308878,122.37766 64.467298,-59.848397 91.457218,1.3175919 c 0,-8e-4 4.76917,-123.4484419 -8.08019,-135.7024419 z"
    var groupIcon = "m 76.492,67.25 c 0,-3.103 -3.504,-16.225 -3.504,-16.225 0,-1.917 -2.521,-4.107 -7.494,-5.384 -2.58,-0.662 -4.744,-2.145 -4.744,-2.145 -0.319,-0.181 -0.27,-1.857 -0.27,-1.857 l -1.602,-0.241 c 0,-0.137 -0.136,-2.145 -0.136,-2.145 1.916,-0.639 1.718,-4.41 1.718,-4.41 1.217,0.67 2.008,-2.311 2.008,-2.311 1.439,-4.145 -0.716,-3.895 -0.716,-3.895 0.685,-3.102 0,-7.635 0,-7.635 -0.958,-8.395 -15.384,-6.116 -13.673,-3.373 -4.215,-0.776 -3.254,8.757 -3.254,8.757 l 0.914,2.464 c -1.796,1.155 -0.548,2.555 -0.487,4.167 0.088,2.377 1.551,1.885 1.551,1.885 0.091,3.924 2.037,4.44 2.037,4.44 0.366,2.464 0.138,2.045 0.138,2.045 l -1.734,0.208 c 0.077,0.623 -0.136,1.671 -0.136,1.671 -2.043,0.902 -2.478,1.432 -4.503,2.312 -3.914,1.704 -8.168,3.92 -8.924,6.904 -0.756,2.984 -3,14.766 -3,14.766 H 76.492 z M 31.682,52.484 v -0.106 l 0.011,-0.104 c 1.12,-4.836 6.947,-7.147 10.128,-8.533 0.005,-0.002 -0.005,0.002 0,0 -1.931,-0.882 -2.95,-1.541 -3.427,-1.649 -0.195,-0.391 -0.614,-3.345 -0.614,-3.345 0,0 2.321,-2.051 2.842,-5.978 0,0 1.143,0.632 1.214,-1.758 0.053,-1.841 0.371,-2.56 -0.882,-3.098 0,0 0.09,-1.274 0.13,-2.405 0.062,-1.676 0.371,-4.028 -2.529,-5.92 -0.412,-0.269 -2.539,-1.452 -2.553,-1.446 -0.758,-0.46 -1.722,-0.753 -1.722,-0.753 l 0.031,0.691 c -0.052,-0.051 -0.104,-0.105 -0.152,-0.152 -0.191,-0.197 -0.299,-0.959 -0.28,-1.261 0.037,-0.536 0.037,-0.536 0.037,-0.536 -1.374,1.025 -2.321,2.35 -2.321,2.35 L 31.718,17.2 c 0,0 -0.255,0.393 -3.398,2.355 -3.084,1.925 -2.573,4.766 -2.488,6.448 0.057,1.13 0.169,1.91 0.169,1.91 -1.252,0.538 -0.596,1.306 -0.564,3.147 0.04,2.547 1.324,2.098 1.324,2.098 0.591,3.469 2.414,5.588 2.414,5.588 0,0 -0.516,2.972 -0.714,3.349 -0.568,0.127 -1.88,1.032 -4.633,2.178 -4.057,1.688 -2.783,0.709 -6.085,2.359 -5.219,2.61 -4.184,13.493 -4.184,13.493 H 30 l 1.682,-7.641 z M 67.484,35.67 c 0,0 -0.5,1.552 -0.578,1.759 -0.078,0.207 -0.558,0.851 -0.454,0.851 0.103,0 1.162,0.491 1.162,0.491 l 4.114,1.278 -0.059,1.938 c -0.361,0.053 -1.782,0.994 -1.989,1.459 -0.135,0.304 -0.436,0.846 -0.725,1.222 3.747,1.511 5.94,3.724 6.029,6.2 0.061,0.442 2.335,8.557 2.465,10.383 h 17.312 c 0.015,-0.075 -0.521,-10.573 -0.526,-10.652 0,0 -0.995,-2.528 -2.57,-2.785 -1.576,-0.259 -3.599,-0.808 -4.445,-1.447 -0.495,-0.376 -2.106,-1.027 -2.853,-1.299 -0.349,-0.125 -0.944,-1.156 -1.15,-1.621 -0.206,-0.465 -1.628,-1.406 -1.99,-1.459 l -0.058,-1.938 4.113,-1.278 c 0,0 1.061,-0.491 1.163,-0.491 0.104,0 -0.491,-0.78 -0.568,-0.988 -0.078,-0.207 -0.465,-1.621 -0.465,-1.621 0,0 1.389,1.698 2.093,2.015 0,0 -1.383,-2.596 -1.795,-4.042 -0.414,-1.447 -0.685,-3.707 -0.685,-3.913 0,-0.208 -0.853,-6.278 -1.318,-7.285 -0.465,-1.009 -1.096,-2.377 -2.176,-3.049 -1.08,-0.672 -2.681,-1.628 -4.98,-1.756 -0.034,-0.002 -0.068,-0.002 -0.103,-0.005 -0.034,0.003 -0.068,0.003 -0.104,0.005 -2.298,0.128 -3.899,1.084 -4.979,1.756 -1.078,0.672 -1.71,2.04 -2.176,3.049 -0.465,1.007 -1.317,7.077 -1.317,7.285 0,0.206 -0.241,2.558 -0.654,4.004 -0.413,1.447 -1.825,3.951 -1.825,3.951 0.704,-0.319 2.091,-2.017 2.091,-2.017 z"
    var skillShareIcon = "m 54.276998,55.055997 c 0,0.768 0.622,1.389 1.39,1.389 h 4.166 v 5.555 c 0,4.601 3.731,8.333 8.334,8.333 h 2.777 v 6.944 h 22.223 v -15.277 -2.807 c 5.05099,-3.802 8.332992,-9.828999 8.332992,-16.638 0,-11.505 -9.326992,-20.833 -20.832992,-20.833 -11.506,0 -20.834,9.328 -20.834,20.833 l -5.436,11.939 h 0.002 c -0.075,0.172 -0.122,0.36 -0.122,0.562 z m 9.312,-18.244 c 0,-2.284 1.382,-4.245 3.359,-5.089 0.536,-2.438 2.697,-4.262 5.296,-4.262 0.138,0 0.263,0.011 0.392,0.018 0.98,-1.431 2.626,-2.369 4.491,-2.369 0.924,0 1.79,0.229 2.551,0.639 0.858,-0.571 1.887,-0.902 2.992,-0.902 1.42,0 2.714,0.553 3.684,1.453 0.406,-0.098 0.826,-0.156 1.266,-0.156 2.194,0 4.092,1.321 4.939,3.213 2.228,0.674 3.84899,2.741 3.84899,5.187 0,0.491 -0.065,0.964 -0.187,1.415 0.695,0.913 1.112,2.051 1.112,3.288 0,1.438 -0.562,2.742 -1.479,3.713 -0.156,2.052001 -1.45499,3.783001 -3.26799,4.563001 v 0.02 c -2.212,1.287 -3.534,3.485999 -3.936,6.123999 h -2.046 v -6.117999 c 0.014,-1.908 0.613,-3.129 1.87,-3.883001 0.46,-0.265 0.878,-0.567 1.234,-0.903 0.934,0.336 1.76,0.994 2.284,1.929001 0.11,0.184 0.306,0.287 0.499,0.287 0.094,0 0.191,-0.023 0.279,-0.074 0.281,-0.153 0.382,-0.503 0.223,-0.777 h -0.004 c -0.589,-1.047001 -1.483,-1.820001 -2.5,-2.280001 0.522,-0.8 0.812,-1.755 0.798,-2.901 0,-0.005 0.008,-0.012 0.008,-0.021 0,-0.517 -0.077,-1.021 -0.215,-1.493 1.194,-0.229 2.247,-0.834 3.021,-1.688 0.215,-0.236 0.199,-0.599 -0.037,-0.81 -0.237,-0.213 -0.594,-0.194 -0.805,0.037 -0.674,0.732 -1.584,1.236 -2.618,1.374 -0.833,-1.541 -2.38,-2.635 -4.192,-2.835 0.12,-0.978 0.561,-1.849 1.225,-2.512 0.218,-0.224 0.218,-0.586 0,-0.807 -0.223,-0.224 -0.59,-0.224 -0.814,0 -0.848,0.849 -1.416,1.984 -1.557,3.249 -2.13,-0.27 -3.771,-2.075 -3.773,-4.276 0,-0.312 -0.261,-0.574 -0.567,-0.574 -0.323,0 -0.577,0.262 -0.577,0.574 0,0.372 0.036,0.726 0.108,1.074 -0.808,0.698 -1.812,1.052 -2.817,1.052 -0.498,0 -0.995,-0.089 -1.465,-0.26 0,0 -0.008,0 -0.014,-0.003 -0.579,-0.209 -1.109,-0.541 -1.569,-1.001 -0.221,-0.222 -0.586,-0.222 -0.81,0 -0.224,0.221 -0.224,0.583 0,0.807 0.473,0.469 1.003,0.834 1.568,1.096 -0.113,1.424 -0.94,2.648 -2.099,3.338 -0.67,-1.018 -1.677,-1.822 -2.912,-2.214 -0.308,-0.098 -0.628,0.071 -0.726,0.372 -0.084,0.3 0.069,0.622 0.374,0.715 0.917,0.292 1.655,0.856 2.187,1.578 -0.357,0.095 -0.723,0.146 -1.112,0.146 0,0 0,0 -0.005,0 h -0.063 c -1.468,0 -2.817,0.586 -3.8,1.542 -0.231,0.22 -0.237,0.582 -0.009,0.807 0.109,0.115 0.259,0.172 0.413,0.172 0.131,0 0.274,-0.053 0.386,-0.162 0.778,-0.758 1.84,-1.216 3.01,-1.216 h 0.061 10e-4 0.006 c 2.752,0 5.039,-2.05 5.396,-4.706 0.393,0.084 0.783,0.13 1.181,0.13 1.117,0 2.243,-0.347 3.192,-1.034 0.348,0.792 0.896,1.484 1.56,2.021 -0.678,0.835 -1.076,1.829 -1.183,2.843 -0.284,-0.046 -0.586,-0.07 -0.887,-0.07 -0.862,0 -1.739,0.205 -2.553,0.64 -0.279,0.148 -0.385,0.495 -0.238,0.776 0.104,0.19 0.305,0.3 0.51,0.3 0.095,0 0.179,-0.021 0.262,-0.069 0.655,-0.343 1.342,-0.506 2.02,-0.506 0.304,0 0.603,0.033 0.887,0.094 0.125,1.158 0.626,2.291 1.487,3.191 0.113,0.118 0.263,0.176 0.409,0.176 0.141,0 0.285,-0.051 0.398,-0.157 0.233,-0.221 0.24,-0.579 0.018,-0.807 h -0.004 c -0.765,-0.809 -1.169,-1.836 -1.196,-2.874 0,-0.016 0.004,-0.027 0,-0.045 0,-0.021 0,-0.042 0,-0.063 0,-1.009 0.349,-2.006 1.039,-2.807 0.728,0.362 1.555,0.573 2.431,0.573 0,0 0.003,0.001 0.01,0.001 0,0 0.004,0 0.009,0 2.374,0.008 4.295,1.926 4.303,4.298 -0.45,-0.119 -0.913,-0.18 -1.389,-0.18 -0.681,0 -1.37,0.125 -2.035,0.399 -0.295,0.121 -0.437,0.451 -0.317,0.743 0.122,0.292 0.451,0.434 0.742,0.314 0.533,-0.213 1.076,-0.316 1.61,-0.316 0.431,0 0.858,0.065 1.26,0.19 -0.14,0.64 -0.414,1.153 -0.84,1.608 -0.032,0.03 -0.063,0.062 -0.088,0.101 -0.327,0.32 -0.718,0.616 -1.2,0.909 -1.653,0.966 -2.447,2.718001 -2.431,4.865001 v 6.118999 h -1.95 v -5.816999 c 0,-2.138 -1.34,-4.163001 -3.027,-4.884001 -0.805,-0.312 -1.645,-0.835 -2.256,-1.521 -0.872,0.593 -1.919,0.941 -3.044,0.941 -1.128,0 -2.174,-0.343 -3.042,-0.932 -0.861,0.567 -1.901,0.899 -3.017,0.899 -3.062,0 -5.537,-2.48 -5.537,-5.539 z m -1.672,8.868001 c 0,-1.343 1.088,-2.430001 2.431,-2.430001 1.343,0 2.43,1.087001 2.43,2.430001 0,1.343 -1.087,2.431 -2.43,2.431 -1.343,0 -2.431,-1.088 -2.431,-2.431 z m -13.316,8.813999 h 0.002 l -5.436,-11.939 c 0,-11.505 -9.328,-20.833 -20.834,-20.833 -11.506,0 -20.833,9.328 -20.833,20.833 0,6.809001 3.282,12.836 8.333,16.638 v 2.807 15.277 h 22.223 v -6.944 h 2.777 c 4.603,0 8.334,-3.732 8.334,-8.333 v -5.556 h 4.166 c 0.768,0 1.39,-0.621 1.39,-1.389 0,-0.201 -0.047,-0.389 -0.122,-0.561 z m -14.725,-12.143 c -1.115,0 -2.155,-0.333 -3.017,-0.899 -0.868,0.589 -1.914,0.932 -3.042,0.932 -1.125,0 -2.172,-0.349 -3.044,-0.941 -0.611,0.685 -1.451,1.208 -2.256,1.521 -1.688,0.721 -3.027,2.747001 -3.027,4.884001 v 5.816999 h -1.95 v -6.118999 c 0.017,-2.147 -0.777,-3.899001 -2.431,-4.865001 -0.482,-0.293 -0.873,-0.589 -1.2,-0.909 -0.024,-0.038 -0.056,-0.071 -0.088,-0.101 -0.426,-0.456 -0.7,-0.968 -0.84,-1.608 0.401,-0.125 0.829,-0.19 1.26,-0.19 0.534,0 1.077,0.103 1.61,0.316 0.291,0.12 0.62,-0.023 0.742,-0.314 0.119,-0.292 -0.022,-0.623 -0.317,-0.743 -0.665,-0.274 -1.354,-0.399 -2.035,-0.399 -0.476,0 -0.938,0.061 -1.389,0.18 0.008,-2.372 1.929,-4.29 4.303,-4.298 0.005,0 0.009,0 0.009,0 0.007,0 0.01,-0.001 0.01,-0.001 0.876,0 1.703,-0.21 2.431,-0.573 0.69,0.8 1.039,1.797 1.039,2.807 0,0.021 0,0.042 0,0.063 -0.004,0.018 0,0.029 0,0.045 -0.027,1.038 -0.432,2.065 -1.196,2.874 h -0.004 c -0.223,0.228 -0.216,0.586 0.018,0.807 0.113,0.106 0.258,0.157 0.398,0.157 0.146,0 0.296,-0.058 0.409,-0.176 0.861,-0.9 1.362,-2.033 1.487,-3.191 0.284,-0.061 0.583,-0.094 0.887,-0.094 0.678,0 1.364,0.163 2.02,0.506 0.083,0.049 0.167,0.069 0.262,0.069 0.205,0 0.405,-0.11 0.51,-0.3 0.146,-0.281 0.041,-0.628 -0.238,-0.776 -0.813,-0.435 -1.69,-0.64 -2.553,-0.64 -0.301,0 -0.603,0.024 -0.887,0.07 -0.106,-1.014 -0.505,-2.007 -1.183,-2.843 0.664,-0.537 1.212,-1.229 1.56,-2.021 0.949,0.687 2.075,1.034 3.192,1.034 0.397,0 0.788,-0.046 1.181,-0.13 0.357,2.656 2.645,4.706 5.396,4.706 h 0.006 0.001 0.061 c 1.17,0 2.231,0.458 3.01,1.216 0.111,0.108 0.255,0.162 0.386,0.162 0.154,0 0.304,-0.057 0.413,-0.172 0.229,-0.225 0.223,-0.587 -0.009,-0.807 -0.982,-0.956 -2.332,-1.542 -3.8,-1.542 h -0.063 c -0.005,0 -0.005,0 -0.005,0 -0.39,0 -0.755,-0.052 -1.112,-0.146 0.531,-0.722 1.27,-1.286 2.187,-1.578 0.305,-0.093 0.458,-0.415 0.374,-0.715 -0.098,-0.301 -0.418,-0.469 -0.726,-0.372 -1.235,0.392 -2.242,1.196 -2.912,2.214 -1.158,-0.689 -1.985,-1.914 -2.099,-3.338 0.565,-0.262 1.096,-0.627 1.568,-1.096 0.224,-0.224 0.224,-0.586 0,-0.807 -0.224,-0.222 -0.589,-0.222 -0.81,0 -0.46,0.46 -0.99,0.792 -1.569,1.001 -0.006,0.003 -0.014,0.003 -0.014,0.003 -0.47,0.171 -0.967,0.26 -1.465,0.26 -1.005,0 -2.01,-0.354 -2.817,-1.052 0.072,-0.349 0.108,-0.703 0.108,-1.074 0,-0.312 -0.254,-0.574 -0.577,-0.574 -0.307,0 -0.567,0.262 -0.567,0.574 -0.003,2.201 -1.644,4.006 -3.773,4.276 -0.141,-1.264 -0.709,-2.399 -1.557,-3.249 -0.225,-0.224 -0.592,-0.224 -0.814,0 -0.218,0.221 -0.218,0.583 0,0.807 0.664,0.663 1.104,1.534 1.225,2.512 -1.812,0.2 -3.359,1.294 -4.192,2.835 -1.034,-0.138 -1.944,-0.642 -2.618,-1.374 -0.211,-0.23 -0.567,-0.25 -0.805,-0.037 -0.236,0.21 -0.252,0.574 -0.037,0.81 0.773,0.854 1.826,1.458 3.021,1.688 -0.138,0.472 -0.215,0.977 -0.215,1.493 0,0.008 0.008,0.015 0.008,0.021 -0.014,1.146 0.275,2.101 0.798,2.901 -1.017,0.459 -1.911,1.233 -2.5,2.280001 h -0.004 c -0.159,0.274 -0.059,0.624 0.223,0.777 0.088,0.051 0.186,0.074 0.279,0.074 0.193,0 0.389,-0.103 0.499,-0.287 0.524,-0.935001 1.351,-1.593001 2.284,-1.929001 0.356,0.336 0.774,0.639 1.234,0.903 1.257,0.754001 1.856,1.975001 1.87,3.883001 v 6.117999 h -2.046 c -0.401,-2.638 -1.724,-4.835999 -3.936,-6.123999 v -0.02 c -1.812,-0.78 -3.111,-2.511 -3.268,-4.563001 -0.917,-0.971 -1.479,-2.276 -1.479,-3.713 0,-1.237 0.417,-2.375 1.112,-3.288 -0.121,-0.45 -0.187,-0.923 -0.187,-1.415 0,-2.445 1.621,-4.513 3.849,-5.187 0.848,-1.892 2.745,-3.213 4.939,-3.213 0.439,0 0.859,0.059 1.266,0.156 0.97,-0.899 2.264,-1.453 3.684,-1.453 1.105,0 2.134,0.331 2.992,0.902 0.761,-0.41 1.627,-0.639 2.551,-0.639 1.865,0 3.511,0.938 4.491,2.369 0.129,-0.007 0.254,-0.018 0.392,-0.018 2.599,0 4.76,1.823 5.296,4.262 1.978,0.844 3.359,2.805 3.359,5.089 -0.002,3.059 -2.477,5.539 -5.537,5.539 z m 4.776,5.760001 c -1.343,0 -2.43,-1.088 -2.43,-2.431 0,-1.343 1.087,-2.430001 2.43,-2.430001 1.343,0 2.431,1.087001 2.431,2.430001 0,1.343 -1.088,2.431 -2.431,2.431 z m 40.625,31.944999 c 0,7.657 -6.23,13.889 -13.889,13.889 h -25 c -4.37,0 -8.255,-2.046 -10.799,-5.211 l 2.7,-1.21 -5.04,-3.642 -5.037,-3.641 -0.634,6.185 -0.635,6.183 3.453,-1.548 c 3.505,5.089 9.356,8.438998 15.991,8.438998 h 25 c 10.722,0 19.444,-8.722998 19.444,-19.443998 h -5.554 z m 0.714,-72.1149978 c -3.505,-5.09 -9.356,-8.43999997 -15.991,-8.43999997 h -25 c -10.722,0 -19.444,8.72299997 -19.444,19.44499777 h 5.556 c 0,-7.658 6.23,-13.8889978 13.889,-13.8889978 h 25 c 4.37,0 8.255,2.044 10.799,5.2109978 l -2.7,1.21 5.04,3.642 5.037,3.641 0.634,-6.185 0.635,-6.1819978 -3.455,1.547 z"
    var projectsIcon = "m 49.996,12.499 49.996,24.274 0,-12.423 L 49.996,0 0,24.35 0,36.773 z m 35.194,35.167 -0.007,0.015 c -0.561,-0.281 -1.185,-0.454 -1.856,-0.454 -1.865,0 -3.425,1.234 -3.956,2.924 l -0.019,-0.008 -3.503,9.583 H 63.884 c -1.534,0 -2.777,1.244 -2.777,2.777 0,1.534 1.244,2.778 2.777,2.778 h 13.888 c 1.087,0 2.018,-0.631 2.475,-1.541 l 0.01,0.005 4.265,-6.587 c 4.688,4.006 6.456,10.466 6.962,16.455 H 79.16 c -2.301,0 -4.166,1.865 -4.166,4.166 v 18.055 c 0,2.301 1.865,4.166 4.166,4.166 2.302,0 4.167,-1.865 4.167,-4.166 V 81.946 h 12.5 c 2.301,0 4.166,-1.865 4.166,-4.167 C 99.992,63.134 94.735,52.438 85.19,47.666 z m -6.723997,-3.216999 c 0,3.45178 -2.79822,6.25 -6.25,6.25 -3.451779,0 -6.25,-2.79822 -6.25,-6.25 0,-3.451779 2.798221,-6.25 6.25,-6.25 3.45178,0 6.25,2.798221 6.25,6.25 z M 66.662,68.058 H 59.33 l -2.461,-7.383 -0.016,0.005 c -0.184,-0.55 -0.688,-0.955 -1.301,-0.955 -0.768,0 -1.389,0.621 -1.389,1.389 0,0.155 0.041,0.296 0.087,0.434 l -0.017,0.005 3.094,9.282 h 9.334 c 0.768,0 1.389,-0.622 1.389,-1.389 0,-0.767 -0.621,-1.388 -1.388,-1.388 z M 36.108,59.726 H 24.144 l -3.503,-9.583 -0.019,0.008 c -0.531,-1.69 -2.091,-2.924 -3.956,-2.924 -0.671,0 -1.295,0.173 -1.856,0.454 L 14.803,47.666 C 5.257,52.438 0,63.134 0,77.779 c 0,2.302 1.865,4.167 4.167,4.167 h 12.499 v 13.888 c 0,2.301 1.865,4.166 4.167,4.166 2.301,0 4.166,-1.865 4.166,-4.166 V 77.779 c 0,-2.301 -1.865,-4.166 -4.166,-4.166 H 8.509 c 0.506,-5.989 2.274,-12.449 6.962,-16.455 l 4.265,6.587 0.01,-0.005 c 0.457,0.91 1.388,1.541 2.475,1.541 h 13.888 c 1.534,0 2.777,-1.244 2.777,-2.778 0,-1.534 -1.244,-2.777 -2.778,-2.777 z M 34.025999,44.449001 c 0,3.45178 -2.79822,6.25 -6.25,6.25 -3.45178,0 -6.25,-2.79822 -6.25,-6.25 0,-3.451779 2.79822,-6.25 6.25,-6.25 3.45178,0 6.25,2.798221 6.25,6.25 z M 45.83,61.114 c 0,-0.768 -0.621,-1.389 -1.389,-1.389 -0.614,0 -1.118,0.404 -1.301,0.955 l -0.016,-0.005 -2.461,7.383 h -7.332 c -0.768,0 -1.389,0.621 -1.389,1.389 0,0.768 0.621,1.389 1.389,1.389 h 9.334 l 3.094,-9.282 -0.017,-0.005 c 0.047,-0.139 0.088,-0.28 0.088,-0.435 z m 16.665,20.832 5.555,0 0,-8.333 -36.108,0 0,8.333 5.555,0 z"
    if (! (this instanceof arguments.callee)) {
        return new arguments.callee(arguments)
    }
    var self = this
    var margin = {top: 20, left: 20, bottom: 20, right: 20}
        , width = parseInt(d3.select('#map').style('width'))
        , width = width - margin.left - margin.right
        , mapRatio = 0.5
        , height = width * mapRatio
        , centered, data, country

    var urls = {world: "/world.json"}

    var parent = document.getElementById('map')
    
    parent.addEventListener('mousemove', self.mouseMoveOverMap, false)
    parent.addEventListener('mouseout', self.mouseOutOfMap, false)

    //this.mouseMoveOverMap = function(e) {
    //    var canvasXY = mouseToCanvasCoordinates(e, parent);
    //    var lonLat = map.canvasXY2LonLat(canvasXY.x, canvasXY.y);
    //    var lon = adjlon(lonLat[0]), lat = lonLat[1];
    //    if (lon > Math.PI || lon < -Math.PI || lat > Math.PI / 2 || lat < -Math.PI / 2) {
    //        writeMouseLonLat("&ndash;", "&ndash;");
    //    }
    //    writeMouseLonLat(formatLongitude(lon), formatLatitude(lat));
    //}

    this.writeMouseLonLat = function(lonText, latText) {
        var infoText = ""
        infoText += "Latitude: " + latText + " Longitude: " + lonText;
        document.getElementById('LegendLabel').innerHTML = infoText;
    }

    this.fileExists = function(url) {
        var http = new XMLHttpRequest()
        http.open('HEAD', url, false)
        http.send()
        return http.status!=404
    }
    
    this.getBBox = function(selection) {
        // get the DOM element from a D3 selection
        // you could also use "this" inside .each()
        var element = selection.node()
            // use the native SVG interface to get the bounding box
        return element.getBBox()
    }

    this.getCentroid = function(selection) {
        // get the DOM element from a D3 selection
        // you could also use "this" inside .each()
        var element = selection.node(),
            // use the native SVG interface to get the bounding box
            bbox = element.getBBox()
        // return the center of the bounding box
        return [bbox.x + bbox.width/2, bbox.y + bbox.height/2]
    }

    this.init = function() {
        //now.receiveLocation = function(message) {
        //    console.log(message)
        //    // FIXME only push markers depending on the country/adm1 level
        //    self.drawMarker(message)
        //}
            self.drawMap()
        //
        //var color_legend = d3.select("#color-legend-svg")
        //  .append("svg:svg")
        //  .attr("width", 225)
        //  .attr("height", 180);
        //color_legend.append("svg:rect")
        //  .attr("width", 80)
        //  .attr("height", 160)
    }

    self.tooltip = undefined

    this.initLegendLabel = function(qtype) {
        "use strict"
        var placeHolder = self.svg.append("g")
            .attr("class", "LegendLabel")
            .attr("transform", "scale(" + 0.7 + ")translate(" + 0 + "," + 0 + ")")
            
        //placeHolder.attr('transform', 'translate(250, 150)')
            
        var fo = placeHolder.append("svg:foreignObject")
            .attr("width", 400)
            .attr("height", 20)
            .attr("class", "LegendLabelObject")

        fo.append("xhtml:div")
            .attr("id", "LegendLabel")
        //fo.attr('transform', 'translate(25, 150)')
    }
    
    this.updateLegendLabel = function(index) {
        "use strict"
        d3.select('#LegendLabel')
            .text(function() {
                var display_string
                if (ZMGC.admin_level === 0) {
                    display_string = index.properties.CONTINENT
                } else if (ZMGC.admin_level === 3) {
                    display_string = index.properties.Name
                } else {
                    display_string = index.properties.NAME
                }
                return display_string
            })
            .transition()
            .duration(800)
    }
    
    this.hideLegendLabel = function(){
      d3.select(".LegendLabel").attr("display", "none");
    }
    
    
    this.showLegendLabel = function(){
      d3.select(".LegendLabel").attr("display", "null");
    }
    
    this.drawTooltip = function() {
        "use strict"
        console.log("drawTooltip")
        var tooltip = d3.select("body").append("g")
            .attr("id", "tooltip")
            .attr("class", "tooltip")
            .style("top", "0px")
            .style("left", "0px")
            .style("opacity", -1)
    
        tooltip.append("polygon")
            .attr("points", "-5, -7, -14, 7 5, 7")
            .attr('transform', 'translate(25, 150)')
    
        tooltip.append('rect')
            .attr('width', 180)
            .attr('height', 88)
            .attr('x', -1)
            .attr('y', 157)
            .attr('rx', 9)
        return tooltip
    }
    
    this.activateTooltip = function(index) {
        "use strict"
        //console.log(index)
        self.tooltip
            .text(function() {
                //var display_string
                
                //if (typeof index.id === 'undefined') {
                //    display_string = index.properties.region
                //} else if (ZMGC.admin_level === 0) {
                //    display_string = index.properties.CONTINENT
                //} else if (ZMGC.admin_level === 1 || ZMGC.admin_level === 2) {
                //    display_string = index.properties.NAME
                //}
                return index
            })
            .transition()
            .duration(500)
            .style("opacity", 1)
    }

    this.deactivateTooltip = function() {
        "use strict"
        self.tooltip.transition()
            .duration(500)
            .style("opacity", -1)
    }

    // Add Icons
    this.drawIcons = function() {
        var s = 0.70
        var iconHolder = self.svg.append("g")
            .attr("class", "map-tools")
            .attr("transform", "scale(" + s + ")translate(" + width * 1.355 + "," + 0 + ")")

        iconHolder.append("svg:path")
            .attr("class", "group-icon")
            .attr("d", groupIcon)
            .attr("transform", "scale(" + s + ")translate(" + 0 + "," + 0 + ")")
            .on("mouseover", function(d) {
                d3.select(this)
                .style("fill", "orange")
                .append("svg:title")
                .text("TZM Groups")
            })
            .on("mouseout", function(d) {
                d3.select(this)
                .style("fill", "#000")
                d3.select(this).select("title").remove()
                //self.deactivateTooltip()
            })

        iconHolder.append("svg:path")
            .attr("class", "projects-icons")
            .attr("d", projectsIcon)
            .attr("transform", "scale(" + s + ")translate(" + 0 + "," + 100 + ")")
            .on("mouseover", function(d) {
                d3.select(this)
                .style("fill", "orange")
                .append("svg:title")
                .text("TZM Projects")
            })
            .on("mouseout", function(d) {
                d3.select(this)
                .style("fill", "#000")
                 d3.select(this).select("title").remove()
                //self.deactivateTooltip()
            })
      
        iconHolder.append("svg:path")
            .attr("class", "skill-share-icon")
            .attr("d", skillShareIcon)
            .attr("transform", "scale(" + s + ")translate(" + 0 + "," + 220 + ")")
            .on("mouseover", function(d) {
                d3.select(this)
                .style("fill", "orange")
                .append("svg:title")
                .text("TZM Skill Share")
            })
            .on("mouseout", function(d) {
                d3.select(this)
                .style("fill", "#000")
                 d3.select(this).select("title").remove()
                //self.deactivateTooltip()
            })
        }

    // Map code
    this.drawMap = function() {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d12c0cde93e9c61ab8514d7d938ec2ed44cf474d
      "use strict"
      var map = d3.geo.equirectangular().scale(150)
      self.path = d3.geo.path().projection(map)

      self.svg = d3.select("#map").append("svg")
        .attr("width", "100%")
        .attr("height", "88%")
        .attr("viewBox", "0 0 " + width + "  "+ height)
        .attr("preserveAspectRatio", "xMidYMid")
        .on("mouseout", self.hideLegendLabel)
        .on("mouseover", self.showLegendLabel)
<<<<<<< HEAD
=======
        "use strict"
        var projection = d3.geo.equirectangular().scale(width)
        self.path = d3.geo.path().projection(projection)
>>>>>>> tzm/master
=======
>>>>>>> d12c0cde93e9c61ab8514d7d938ec2ed44cf474d

        var map = d3.select('#map').append('svg')
                .style('height', height + 'px')
                .style('width', width + 'px')
        queue()
            .defer(d3.json, urls.world)
            .await(self.render)
        // catch the resize
        d3.select(window).on('resize', self.resize)
      //self.svg = d3.select("#map").append("svg")
      //  .attr("width", width)
      //  .attr("height", height)
      //  .attr("viewBox", "0 0 " + width + "  "+ height)
      //  .attr("preserveAspectRatio", "xMidYMid")
//
      // Add a transparent rect so that zoomMap works if user clicks on SVG
      //self.map.append("rect")
      //  .attr("class", "background")
      //  .attr("width", width)
      //  .attr("height", height)
      //  //.on("click", self.zoomMap)
      //  .on("mousemove", function(d) {
      //      var lonlat = map.invert(d3.mouse(this))
      //      var lonText = formatLongitude(lonlat[0])
      //      var latText = formatLatitude(lonlat[1])
      //      self.writeMouseLonLat(lonText, latText)
      //  })

      // Add g element to load country paths
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d12c0cde93e9c61ab8514d7d938ec2ed44cf474d
      self.g = self.svg.append("g")
        .attr("id", "countries")
      // Load topojson data
      d3.json("/world.json", function(topology) {
        self.g.selectAll("path")
        //.data(topology.features)
        .data(topojson.object(topology, topology.objects.countries).geometries)
          .enter().append("path")
          .attr("d", self.path)
          .attr("id", function(d) {
            return d.properties.name.replace(/ /g,"_")
          })
          //.attr("class", data ? self.quantize : null)
          .on("mousemove", function(d) {
              var lonlat = map.invert(d3.mouse(this))
              var lonText = formatLongitude(lonlat[0])
              var latText = formatLatitude(lonlat[1])
              self.writeMouseLonLat(lonText, latText)
          })
          .on("mouseover", function(d) {
              d3.select(this)
                .style("fill", "orange")
                .append("svg:title")
                //use CLDR to localize country name
                .text(d.properties.name)
            //self.activateTooltip(d.properties.name)
          })
          .on("mouseout", function(d) {
            d3.select(this)
            .style("fill", "#aaa")
             d3.select(this).select("title").remove()
            //self.deactivateTooltip()
          })
          .on("click", function(d) {
            var b = self.getBBox(d3.select(this))
            self.svg.selectAll("#"+self.country).style("opacity", 1)
            self.country = d.properties.name.replace(/ /g,"_")
            self.svg.selectAll("#"+self.country).style("opacity", 0)
            self.zoomMap(d, b)
          })
          // Remove Antarctica
          //self.g.select("#Antarctica").remove()
        })
      // Add icons - these go last as we want them to sit on top layer
      self.initLegendLabel()
      self.drawIcons()
<<<<<<< HEAD
=======
      //self.g = self.svg.append("g")
      //  .attr("id", "countries")
      //// Load topojson data
      //d3.json("/world.json", function(topology) {
      //  self.g.selectAll("path")
      //  //.data(topology.features)
      //  .data(topojson.object(topology, topology.objects.countries).geometries)
      //    .enter().append("path")
      //    .attr("d", self.path)
      //    .attr("id", function(d) {
      //      return d.properties.name.replace(/ /g,"_")
      //    })
      //    //.attr("class", data ? self.quantize : null)
      //    .on("mousemove", function(d) {
      //        var lonlat = map.invert(d3.mouse(this))
      //        var lonText = formatLongitude(lonlat[0])
      //        var latText = formatLatitude(lonlat[1])
      //        self.writeMouseLonLat(lonText, latText)
      //    })
      //    .on("mouseover", function(d) {
      //        d3.select(this)
      //          .style("fill", "orange")
      //          .append("svg:title")
      //          //use CLDR to localize country name
      //          .text(d.properties.name)
      //      //self.activateTooltip(d.properties.name)
      //    })
      //    .on("mouseout", function(d) {
      //      d3.select(this)
      //      .style("fill", "#aaa")
      //      //self.deactivateTooltip()
      //    })
      //    .on("click", function(d) {
      //      var b = self.getBBox(d3.select(this))
      //      self.svg.selectAll("#"+self.country).style("opacity", 1)
      //      self.country = d.properties.name.replace(/ /g,"_")
      //      self.svg.selectAll("#"+self.country).style("opacity", 0)
      //      self.zoomMap(d, b)
      //    })
      //    // Remove Antarctica
      //    //self.g.select("#Antarctica").remove()
      //  })
      //// Add icons - these go last as we want them to sit on top layer
      //self.initLegendLabel()
      //self.drawIcons()
>>>>>>> tzm/master
=======

>>>>>>> d12c0cde93e9c61ab8514d7d938ec2ed44cf474d
    } // end drawMap
    this.render = function(err, world) {
      "use strict"
      console.log("we render")
      var countries = topojson.mesh(world, world.objects.countries)
      window.world = world
      //map.append('path')
      //  .datum(world)
      //  .attr('class', 'world')
      //  .attr('d', path)

    }
    this.resize = function() {
      "use strict"
      console.log("we resize")
    }
    this.zoomMap = function(d, b) {
      "use strict"
      // get the ratio of the ViewBox height in relation to the country bbox height
      var ratio = b.height / height
      var x, y, k
      if (d && centered !== d) {
        var centroid = self.path.centroid(d)
        x = centroid[0]
        y = centroid[1]
        // FRANCE exception
        if (d.id !== "FRA") {
          k = 1/ratio - 1
        } else {
          k = 1/ratio
        }
        console.log(k, ratio)
        centered = d
        self.loadCountry(d, x, y, k)
      } else {
        // zoom out, this happens when user clicks on the same country
        x = width / 2
        y = height / 2
        k = 1
        centered = null
        // as we zoom out we want to remove the country layer
        self.svg.selectAll("#"+self.country).style("opacity", 1)
        self.svg.selectAll("#country").remove()
      }
      //select all the countries paths
      self.g.selectAll("path")
        .classed("active", centered && function(d) {
            return d === centered
            })

      self.g.transition()
        .duration(1000)
        .delay(100)
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")")
        .style("stroke-width", 0.5 / k + "px")
      
    } // end zoom function

    this.loadCountry = function(d, x, y, k) {
      "use strict"
      // we remove the country
      self.svg.selectAll("#country").remove()
      // load country json file
      var adm1_key = d.id+"_adm1"
      var adm1_path = "/"+d.id+"_adm1.json"
      // check to see if country file exists
      if (!self.fileExists(adm1_path)) {
        self.svg.selectAll("#"+self.country).style("opacity", 1)
        console.log("We couldn't find that country!")
      } else {
        console.log("Load country overlay")
        var country = self.svg.append("g").attr("id", "country")
        self.countryGroup = self.svg.select("#country")
        d3.json(adm1_path, function(error, topology) {
          var regions = topology.objects
          for(var adm1_key in regions) { 
            var o = regions[adm1_key]
          }
          self.countryGroup.selectAll("path")
            .data(topojson.object(topology, o).geometries)
            .enter().append("path")
            .attr("d", self.path)
            .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")scale(" + k + ")translate(" + -x + "," + -y + ")")
            .attr("id", function(d) {
              return d.properties.NAME_1
            })
            .classed("country", true)
            .attr("class", "country")
            .style("stroke-width", 1.5 / k + "px")
            .on("mouseover", function(d) {
              d3.select(this)
              .style("fill", "#6C0")
              .append("svg:title")
              .text(d.properties.NAME_1)
            })
            .on("mouseout", function(d) {
              d3.select(this)
              .style("fill", "#000000")
              d3.select(this).select("title").remove()
            })
            .on("click", function(d) {
              console.log('clicked on country')
              self.loadProjects()
            })
          })
        } // end else
    }

    this.loadProjects = function() {
      console.log('loadProjects')

    } // end loadProjects

    this.LonLat = function(d) {
      // get Lon/Lat of mouse
      console.log(map.invert(d3.mouse(d)))
    }
    this.loadMembers = function () {
        // Load data from .json file on page refresh
        var data = [{ city: 'Centreville',
              longitude: -77.46070098876953,
              latitude: 38.81589889526367,
              ip: '72.196.192.58',
              timestamp: 1342997755637 }]
        for ( var i in data ) { 
                this.drawMarker( data[i] ) 
            }
        console.log('we load members from db...')
    }

    this.drawMarker = function (message) {
        var longitude = message.longitude,
            latitude = message.latitude,
            text = message.title,
            city = message.city

        var coordinates = self.map([longitude, latitude])
            x = coordinates[0]
            y = coordinates[1]

        var member = self.svg.append("svg:path")
        member.attr("d", personPath)
        member.attr("transform", "translate(" + x + "," + y + ")scale(0.020)")
        member.style("fill", "steelblue")
        member.attr("class", "member")
        member.on("mouseover", function(){
            d3.select(this).transition()
            .style("fill", "red")
            .attr("transform", "translate(" + x + "," + y + ")scale(0.035)")
        })
        member.on("mouseout", function() {
            d3.select(this).transition()
            .style("fill", "steelblue")
            .attr("transform", "translate(" + x + "," + y + ")scale(0.020)")
        })

        var cityName = self.svg.append("svg:text")
            cityName.text(function(d) { return city })
            cityName.attr("x", x)
            cityName.attr("dy", y + 12)
            cityName.attr('text-anchor', 'middle')
            cityName.attr("class", "city-name")
            cityName.style("fill", "red")
            cityName.transition().delay(4000)
            .style("opacity", "0")

        //console.log($(member.node))
        //var hoverFunc = function () {
        //    console.log('hoverFunc')
        //    //person.attr({
        //    //    fill: 'white'
        //    //})
        //    //$(title.node).fadeIn('fast')
        //    //$(subtitle.node).fadeIn('fast')
        //}
        //
        //var hideFunc = function () {
        //    console.log('hideFunc')
        //    //person.attr({
        //    //    fill: '#ff9'
        //    //})
        //    //$(title.node).fadeOut('slow')
        //    //$(subtitle.node).fadeOut('slow')
        //}
        //$(member.node).hover(hoverFunc, hideFunc)
    }
    // Initialise
    this.init()
}).call(this);

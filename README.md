# SCENIC- Accelerator v2

## Getting Started
---
**1. Run the python script inside src/utils folder to generate test-data for the testbench.**
<pre><code>
$ pip3 install numpy
$ python3 conv.py
</code></pre>

**2. For test Convolution-3D, modify the stride, channels and num_filter arguments in line #234 and dimensions of activations & filters in line #129, #130.**


**3. Open ModelSim application**

**4. Click File button on the top left of the application and go-to change directory. Go-to scenic_accelerator_v2/ directory where the repository is cloned**

**5. In the bottom "transcript" window, type the below command**
<pre><code>
$ source modelsim_compile.do
</code></pre>

**8. Following data will be visibile in the transcript window at the bottom**
<pre><code>
# blk_h:           2, blk_w =           2
# mode: block mode
# run:           1
# run:           2
# run:           3
# run:           4
# run:           5
# run:           6
# run:           7
# run:           8
# cycle_count:       10368
# op_count:       64800
# s1_c:         144
# s2_c:        1440
# s3_c:        4320
# s4_c:           0
# s5_c:        3888
# s6_c:           0
# s7_c:           0
# ------------------------------------------------
# 
#                   TEST PASSED                   
# 
# ------------------------------------------------
# 
# Total number of cycles:       10368
</code></pre>
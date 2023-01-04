# SCENIC- Accelerator v2

## Getting Started
---
**1. Run the python script inside src/utils folder to generate test-data for the testbench.**
<pre><code>
$ pip3 install numpy
$ python3 conv.py
</code></pre>

**2. For test Convolution-3D, modify the stride, channels and num_filter arguments in line #234 and dimensions of activations & filters in line #129, #130.**


**3. Open the modelsim project file** *(brain-tumor-nn-accelerator.mpf)* **inside modelsim-prj folder.**

**4. Compile all the verilog source files in modelsim.**


**5. Open the simulation for conv_tb module.**


**6. Load the macro file** *(modelsim-prj/conv_wave.do)* **for generating the waveform format.**

**7. Click Run -All button to complete the entire simulation. Click No for the popup "Are you sure you want to finish?"**

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
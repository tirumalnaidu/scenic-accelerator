## Getting Started


1. Run the python script inside <code>src/utils</code> folder to generate test-data for the testbench.
<pre><code>$ pip3 install numpy
$ python3 conv.py
</code></pre>

<<<<<<< HEAD
**3. Open ModelSim application**

**4. Click File button on the top left of the application and go-to change directory. Go-to scenic_accelerator_v2/ directory where the repository is cloned**

**5. In the bottom "transcript" window, type the below command**
<pre><code>
$ source modelsim_compile.do
</code></pre>
=======
2. For test Convolution-3D, modify the stride, channels and num_filter arguments in <code>line #234</code> and dimensions of activations & filters in <code>line #129, #130</code>
<br/><br/>

3. Open the modelsim project file <code>(brain-tumor-nn-accelerator.mpf)</code> inside modelsim-prj folder.
<br/><br/>

4. Compile all the verilog source files in modelsim.
<br/><br/>

5. Open the simulation for conv_tb module.
<br/><br/>

6. Load the macro file** <code>(modelsim-prj/conv_wave.do)</code> **for generating the waveform format.
<br/><br/>

7. Click Run -All button to complete the entire simulation. Click No for the popup "Are you sure you want to finish?"
<br/><br/>
>>>>>>> 8e4370089fe9c206c810ef9ec2d155052a3577e9

8. Following data will be visibile in the transcript window at the bottom
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
<br/><br/>

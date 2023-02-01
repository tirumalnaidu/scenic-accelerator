# Simply change the project settings in this section
# for each new project. There should be no need to
# modify the rest of the script.

set tb_name conv_tb

set library_file_list [list \
  work [list \
    src/rtl/booth_mult.sv \
    src/rtl/dnn_hw_top.sv \
    src/rtl/fifo_buffer_bank.sv \
    src/rtl/fifo.sv \
    src/rtl/ml_ctrl_fsm.sv \
    src/rtl/muxes.sv \
    src/rtl/pe_array.sv \
    src/rtl/pe.sv \
    src/rtl/regfile.sv \
    src/rtl/serial_adder.sv \
    src/rtl/simple_dpram_sclk.sv \
    src/tb/conv_tb.sv
    ] \
]
set incdir_list [list \
  src/rtl \
  src/tb \
]
set top_level work.$tb_name

# After sourcing the script from ModelSim for the
# first time use these commands to recompile.
proc r  {} {
  write format wave -window .main_pane.wave.interior.cs.body.pw.wf wave.do
  uplevel #0 source run_tb.do
}
proc rr {} {global last_compile_time
            set last_compile_time 0
            r                            }
proc q  {} {quit -force                  }

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

# Prefer a fixed point font for the transcript
set PrefMain(font) {Courier 10 roman normal}

# Compile out of date files
set incdir_str_ ""
foreach incdir $incdir_list {
    append incdir_str_ " +incdir+" $incdir
}
set incdir_str [string trim $incdir_str_ " "]

set time_now [clock seconds]
if [catch {set last_compile_time}] {
  set last_compile_time 0
}
foreach {library file_list} $library_file_list {
  vlib $library
  vmap work $library
  foreach file $file_list {
    if { $last_compile_time < [file mtime $file] } {
      if [regexp {.vhdl?$} $file] {
        vcom -93 $file
      } else {
        vlog +define+SIM -sv05compat -timescale "1 ns / 1 ps" $file {*}[split $incdir_str " "]
      }
      set last_compile_time 0
    }
  }
}
set last_compile_time $time_now

# Load the simulation
eval vsim $top_level

# If waves exists
if [file exist wave.do] {
  source modelsim-prj/conv_wave.do
}

run -all
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2.2 (lin64) Build 6060944 Thu Mar 06 19:10:09 MST 2025
//Date        : Mon Sep 29 01:53:58 2025
//Host        : pop-os running 64-bit Pop!_OS 22.04 LTS
//Command     : generate_target vio.bd
//Design      : vio
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "vio,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=vio,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "vio.hwdef" *) 
module vio
   (clk_0,
    probe_in0_0,
    probe_in1_0,
    probe_in2_0,
    probe_out0_0,
    probe_out1_0,
    probe_out2_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN vio_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_0;
  input [3:0]probe_in0_0;
  input [3:0]probe_in1_0;
  input [3:0]probe_in2_0;
  output [0:0]probe_out0_0;
  output [0:0]probe_out1_0;
  output [3:0]probe_out2_0;

  wire clk_0_1;
  wire [3:0]probe_in0_0_1;
  wire [3:0]probe_in1_0_1;
  wire [3:0]probe_in2_0_1;
  wire [0:0]vio_0_probe_out0;
  wire [0:0]vio_0_probe_out1;
  wire [3:0]vio_0_probe_out2;

  assign clk_0_1 = clk_0;
  assign probe_in0_0_1 = probe_in0_0[3:0];
  assign probe_in1_0_1 = probe_in1_0[3:0];
  assign probe_in2_0_1 = probe_in2_0[3:0];
  assign probe_out0_0[0] = vio_0_probe_out0;
  assign probe_out1_0[0] = vio_0_probe_out1;
  assign probe_out2_0[3:0] = vio_0_probe_out2;
  vio_vio_0_0 vio_0
       (.clk(clk_0_1),
        .probe_in0(probe_in0_0_1),
        .probe_in1(probe_in1_0_1),
        .probe_in2(probe_in2_0_1),
        .probe_out0(vio_0_probe_out0),
        .probe_out1(vio_0_probe_out1),
        .probe_out2(vio_0_probe_out2));
endmodule

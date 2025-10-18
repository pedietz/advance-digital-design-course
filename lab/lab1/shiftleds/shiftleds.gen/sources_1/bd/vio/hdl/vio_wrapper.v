//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2.2 (lin64) Build 6060944 Thu Mar 06 19:10:09 MST 2025
//Date        : Mon Sep 29 01:53:58 2025
//Host        : pop-os running 64-bit Pop!_OS 22.04 LTS
//Command     : generate_target vio_wrapper.bd
//Design      : vio_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module vio_wrapper
   (clk_0,
    probe_in0_0,
    probe_in1_0,
    probe_in2_0,
    probe_out0_0,
    probe_out1_0,
    probe_out2_0);
  input clk_0;
  input [3:0]probe_in0_0;
  input [3:0]probe_in1_0;
  input [3:0]probe_in2_0;
  output [0:0]probe_out0_0;
  output [0:0]probe_out1_0;
  output [3:0]probe_out2_0;

  wire clk_0;
  wire [3:0]probe_in0_0;
  wire [3:0]probe_in1_0;
  wire [3:0]probe_in2_0;
  wire [0:0]probe_out0_0;
  wire [0:0]probe_out1_0;
  wire [3:0]probe_out2_0;

  vio vio_i
       (.clk_0(clk_0),
        .probe_in0_0(probe_in0_0),
        .probe_in1_0(probe_in1_0),
        .probe_in2_0(probe_in2_0),
        .probe_out0_0(probe_out0_0),
        .probe_out1_0(probe_out1_0),
        .probe_out2_0(probe_out2_0));
endmodule

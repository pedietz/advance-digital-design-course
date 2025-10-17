//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2.2 (lin64) Build 6060944 Thu Mar 06 19:10:09 MST 2025
//Date        : Mon Sep 29 01:57:33 2025
//Host        : pop-os running 64-bit Pop!_OS 22.04 LTS
//Command     : generate_target ila_wrapper.bd
//Design      : ila_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ila_wrapper
   (clk_0,
    probe0_0);
  input clk_0;
  input [3:0]probe0_0;

  wire clk_0;
  wire [3:0]probe0_0;

  ila ila_i
       (.clk_0(clk_0),
        .probe0_0(probe0_0));
endmodule

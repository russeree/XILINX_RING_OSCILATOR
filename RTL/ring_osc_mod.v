//////////////////////////////////////////////////////////////////////////////////
// Creator: Reese Russell 
// 
// Create Date: 12/03/2015 06:40:11 PM
// Design Name: Ring Oscilator
// Module Name: ring_osc_mod
// Project Name: Timing Tester
// Target Devices: Kintex 7 325T
// Tool Versions: Vivado 2015.4
// Description: Ring Oscilator
// 
// Dependencies: XILINX/LATTICE  ONLY
// 
// Revision: 1.04
// Revision 0.01 - File Created
// Additional Comments: XILINX SYNTHESIS TOOLS REQUIRE THE BELOW TO BE ADDED  
// "set_property SEVERITY {Warning} [get_drc_checks LUTLP-1]" to the constraints file
// if this statement is not included a race condition synthesis error will occour
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps 

/* Uncoment HDL Language */ 
`define _SYSTEM_VERILOG 1  // SYSTEM VERILOG   
//`define _VERILOG 1 // VERILOG 

/* Uncoment architecture for synthesis */
`define _ARCH_XILINX  1 // XILINX
// `define _ARCH_LATTICE 1 // LATTICE

/* Ring oscilator */
module ring_osc_mod(clk_o);
    /* Output clock*/
    output  clk_o;
    /* Define the ring length */ 
    parameter _ring_length = 3;
`ifdef _SYSTEM_VERILOG
    /* Check for multiple vendor degfinition */ 
    if (`ifdef `_ARCH_XILINX  1 +`endif 0 && `ifdef `_ARCH_LATTICE  1 + `endif 0) begin
        $error ("Only one vendor definition may be used");
    end
    /* Define the ring length */ 
    if ((_ring_length %2) == 0) begin
        $error ("Parameter ring length expects an odd integer");
    end
`endif
    /* Ring logic with synthesis driectives */
`ifdef _ARCH_XILINX (* dont_touch="true" *) `endif
`ifdef _ARCH_LATTICE (* syn_keep=1 *); `endif
    wire [_ring_length - 1:0] clk_int;
    /* Generate logic */
    genvar i;
    generate
        for (i=0; i < _ring_length; i= (i+1)) begin : ring_gen
            if(i == 0) begin: ring_end
                assign clk_int[i] = ~clk_int[_ring_length-1];
            end
            else begin: ring_chain
                assign clk_int[i] = ~clk_int[i-1];
            end 
        end
    endgenerate
    
    /* Assign the output */ 
    assign clk_o = clk_int[0]; 

endmodule

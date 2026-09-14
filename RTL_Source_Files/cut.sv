module cut (
  input logic clk,
  input logic [3:0] in,
  output logic  out 
);
  
assign out = (in[0] & in[1]) | (in[2] & in[3]);
endmodule
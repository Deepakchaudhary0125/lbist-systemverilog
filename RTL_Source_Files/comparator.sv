module comparator #(parameter REG_WIDTH = 4) (
  input logic clk, rstn,
  input logic [REG_WIDTH-1:0] Sign_Good,

  input  logic [REG_WIDTH-1:0] Sign_F_at_A,Sign_F_at_Abar,
        Sign_F_at_B,Sign_F_at_Bbar,
        Sign_F_at_C,Sign_F_at_Cbar,
        Sign_F_at_D,Sign_F_at_Dbar,
        Sign_F_at_X,Sign_F_at_Xbar,
        Sign_F_at_Y,Sign_F_at_Ybar,
  
  output logic   Det_A, Det_Abar,
        Det_B, Det_Bbar,
        Det_C, Det_Cbar,
        Det_D, Det_Dbar,
        Det_X, Det_Xbar,
        Det_Y, Det_Ybar,
  output logic [3:0] num_detected

  
);
//compare each faulted output with Ideal Output 
assign Det_A    = (Sign_F_at_A !== Sign_Good);
assign Det_Abar = (Sign_F_at_Abar !== Sign_Good);
assign Det_B    = (Sign_F_at_B !== Sign_Good);
assign Det_Bbar = (Sign_F_at_Bbar !== Sign_Good);
assign Det_C    = (Sign_F_at_C !== Sign_Good);
assign Det_Cbar = (Sign_F_at_Cbar !== Sign_Good);
assign Det_D    = (Sign_F_at_D !== Sign_Good);
assign Det_Dbar = (Sign_F_at_Dbar !== Sign_Good);
assign Det_X    = (Sign_F_at_X !== Sign_Good);
assign Det_Xbar = (Sign_F_at_Xbar !== Sign_Good);
assign Det_Y    = (Sign_F_at_Y !== Sign_Good);
assign Det_Ybar = (Sign_F_at_Ybar !== Sign_Good);

    // Count detections
always_comb begin
  num_detected = Det_A + Det_Abar
               + Det_B + Det_Bbar
               + Det_C + Det_Cbar
               + Det_D + Det_Dbar
               + Det_X + Det_Xbar
               + Det_Y + Det_Ybar;
end


endmodule
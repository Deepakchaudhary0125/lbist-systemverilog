`timescale 1ns/1ps

module stuck_at_models #(
  parameter int REG_WIDTH = 4
)(
  input logic [3:0] in,
  input  logic [3:0] smodel, 
  output logic GoodF,
  output logic F_at_A,F_at_Abar,
               F_at_B,F_at_Bbar,
               F_at_C,F_at_Cbar,
               F_at_D,F_at_Dbar,
               F_at_X,F_at_Xbar,
               F_at_Y,F_at_Ybar

);

   assign GoodF = (in[0] & in[1]) | (in[2] & in[3]);

   always @(*)  begin

    F_at_A    = GoodF;
    F_at_Abar = GoodF;
    F_at_B    = GoodF;
    F_at_Bbar = GoodF;
    F_at_C    = GoodF;
    F_at_Cbar = GoodF;
    F_at_D    = GoodF;
    F_at_Dbar = GoodF;
    F_at_X    = GoodF;
    F_at_Xbar = GoodF;
    F_at_Y    = GoodF;
    F_at_Ybar = GoodF;

    case(smodel)

      4'd0: F_at_A    = (1 & in[1]) | (in[2] & in[3]);
      4'd1: F_at_Abar = (0 & in[1]) | (in[2] & in[3]);

      4'd2: F_at_B    = (in[0] & 1 ) | (in[2] & in[3]);
      4'd3: F_at_Bbar = (in[0] & 0) | (in[2] & in[3]);

      4'd4: F_at_C    = (in[0] & in[1]) | (1 & in[3]);
      4'd5: F_at_Cbar = (in[0] & in[1]) | (0 & in[3]);

      4'd6:F_at_D     = (in[0] & in[1]) | (in[2] & 1);
      4'd7:F_at_Dbar  = (in[0] & in[1]) | (in[2] & 0);

      4'd8:F_at_X     =  1 | (in[2] & in[3]);
      4'd9:F_at_Xbar  =  0 | (in[2] & in[3]);

      4'd10:F_at_Y    = (in[0] & in[1]) | 1 ;
      4'd11:F_at_Ybar = (in[0] & in[1]) | 0 ;

      default: ;

    endcase
    
  
  end


  
endmodule
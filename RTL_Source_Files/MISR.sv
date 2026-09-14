module MISR #(
    parameter int REG_WIDTH = 4
)(
    input  logic                 clk,
    input  logic                 rstn,
    input  logic                 en,        // compress only while a pattern is being applied
    input  logic [REG_WIDTH-1:0] smodel, 
    input  logic F_at_A,F_at_Abar,
                F_at_B,F_at_Bbar,
                F_at_C,F_at_Cbar,
                F_at_D,F_at_Dbar,
                F_at_X,F_at_Xbar,
                F_at_Y,F_at_Ybar,
                GoodF,

    output logic [REG_WIDTH-1:0] Sign_F_at_A,Sign_F_at_Abar,
                Sign_F_at_B,Sign_F_at_Bbar,
                Sign_F_at_C,Sign_F_at_Cbar,
                Sign_F_at_D,Sign_F_at_Dbar,
                Sign_F_at_X,Sign_F_at_Xbar,
                Sign_F_at_Y,Sign_F_at_Ybar,
                Sign_Good
 
  );


    function automatic  [REG_WIDTH-1:0] misr_next(
      input  [REG_WIDTH-1:0] curr,
      input  d);
    
        
        misr_next[0] = d ^ curr[3];
        misr_next[1] =  curr[0];
        misr_next[2] = curr[1] ^ curr[3];
        misr_next[3] =  curr[2];


    endfunction

    localparam  [REG_WIDTH-1:0] SEED = 4'b1000; 


    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            Sign_F_at_A     <=SEED;  
            Sign_F_at_Abar  <=SEED;  
            Sign_F_at_B     <=SEED;  
            Sign_F_at_Bbar  <=SEED; 
            Sign_F_at_C     <=SEED;  
            Sign_F_at_Cbar  <=SEED;  
            Sign_F_at_D     <=SEED;  
            Sign_F_at_Dbar  <=SEED;  
            Sign_F_at_X     <=SEED;  
            Sign_F_at_Xbar  <=SEED;  
            Sign_F_at_Y     <=SEED;  
            Sign_F_at_Ybar  <=SEED;  
            Sign_Good       <=SEED; 
        end
        else if (en)
          begin
            Sign_F_at_A     <= misr_next(Sign_F_at_A,     F_at_A);
            Sign_F_at_Abar  <= misr_next(Sign_F_at_Abar,  F_at_Abar);
            Sign_F_at_B     <= misr_next(Sign_F_at_B,     F_at_B);
            Sign_F_at_Bbar  <= misr_next(Sign_F_at_Bbar,  F_at_Bbar);
            Sign_F_at_C     <= misr_next(Sign_F_at_C,     F_at_C);
            Sign_F_at_Cbar  <= misr_next(Sign_F_at_Cbar,  F_at_Cbar);
            Sign_F_at_D     <= misr_next(Sign_F_at_D,     F_at_D);
            Sign_F_at_Dbar  <= misr_next(Sign_F_at_Dbar,  F_at_Dbar);
            Sign_F_at_X     <= misr_next(Sign_F_at_X,     F_at_X);
            Sign_F_at_Xbar  <= misr_next(Sign_F_at_Xbar,  F_at_Xbar);
            Sign_F_at_Y     <= misr_next(Sign_F_at_Y,     F_at_Y);
            Sign_F_at_Ybar  <= misr_next(Sign_F_at_Ybar,  F_at_Ybar);
            Sign_Good       <= misr_next(Sign_Good,       GoodF); 

          end
    end

endmodule
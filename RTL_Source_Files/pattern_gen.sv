module pattern_lfsr #(
    parameter int REG_WIDTH = 4
)(
    input  logic                 clk,
    input  logic                 rstn,
    input logic start,
    output logic [REG_WIDTH-1:0] out
);

    logic feedback;

    assign feedback = out[REG_WIDTH-1] ^ out[0];

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn)
            out <= 4'b0001;  // non-zero seed
        else if (start)
            out <= {feedback,out[3:1]};
    end

endmodule
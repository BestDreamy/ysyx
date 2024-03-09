module alu #(parameter WIDTH = 4) (
    input  wire signed[WIDTH - 1: 0] srcA_i,
    input  wire signed[WIDTH - 1: 0] srcB_i,
    input  wire       [        2: 0] sel_i,
    output reg  signed[WIDTH - 1: 0] res_o,
    output reg                       zf_o,
    output reg                       of_o,
    output reg                       cf_o // carry
);

    always @(*) begin
        {zf_o, of_o, cf_o} = 3'b000;
        case (sel_i) 
            3'b000: begin
                {cf_o, res_o} = srcA_i + srcB_i;
                zf_o          = res_o == 0;
                of_o          = (srcA_i[WIDTH - 1] == srcB_i[WIDTH - 1]) && (srcA_i[WIDTH - 1] != res_o[WIDTH - 1]);
            end
            3'b001: begin
                {cf_o, res_o} = srcA_i - srcB_i;
                zf_o          = res_o == 0;
                of_o          = (~srcA_i[WIDTH - 1] == srcB_i[WIDTH - 1]) && (srcA_i[WIDTH - 1] != res_o[WIDTH - 1]);
            end
            3'b010: begin
                res_o = ~srcA_i;
            end
            3'b011: begin
                res_o = srcA_i & srcB_i;
            end
            3'b100: begin
                res_o = srcA_i | srcB_i;
            end
            3'b101: begin
                res_o = srcA_i ^ srcB_i;
            end
            3'b110: begin
                res_o = {WIDTH{srcA_i < srcB_i}};
            end
            3'b111: begin
                res_o = {WIDTH{srcA_i == srcB_i}};
            end
        endcase
    end

endmodule

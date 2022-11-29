module signed_extension(immI,sign_extended_I,opcode);
    input logic[11:0]immI;
    output logic[31:0]sign_extended_I;
    input logic[6:0] opcode;
    always_comb begin
            if (opcode == 7'b0010011 || opcode == 7'b0000011)begin
                sign_extended_I[11:0] = immI[11:0];
                sign_extended_I[31:12] = {20{immI[11]}}; 
        end
    end
endmodule
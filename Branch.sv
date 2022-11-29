module Branch(forwarded_A,forwarded_B,br_taken,opcode,fun3,br_taken);
    input logic[31:0]forwarded_A,forwarded_B;
    input logic[6:0]opcode;
    input logic[2:0]fun3;
    output logic br_taken;

    always_comb begin 
        br_taken = 0;
        if (opcode == 7'b1100011)begin
            case (fun3)
                3'b000:br_taken = (forwarded_A == forwarded_B) ? 1 : 0;
                3'b001:br_taken = (forwarded_A != forwarded_B) ? 1 : 0;
                3'b100:br_taken = ($signed(forwarded_A) <  $signed(forwarded_B)) ? 1 : 0;
                3'b101:br_taken = ($signed(forwarded_A) >  $signed(forwarded_B)) ? 1 : 0;
                3'b110:br_taken = (forwarded_A <  forwarded_B) ? 1 : 0;
                3'b111:br_taken = (forwarded_A >  forwarded_B) ? 1 : 0;
            endcase
        end
        if (opcode == 7'b1101111)begin
            br_taken = 1;
        end
        if (opcode == 7'b1100111)begin
            br_taken = 1;
        end
    end


endmodule
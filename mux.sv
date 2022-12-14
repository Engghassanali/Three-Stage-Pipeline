module mux_I(sel_B,forwarded_B,sign_extended_I,readData2);
    input logic[31:0]forwarded_B,sign_extended_I;
    input logic sel_B;
    output logic[31:0]readData2;

    always_comb begin 
        case (sel_B)
            0:readData2 = forwarded_B;
            1:readData2 = sign_extended_I; 
        endcase
    end
endmodule

module mux_LS(wb_sel_E,Alu_out_E,load,wdata,PC_E);
    input logic[1:0]wb_sel_E;
    input logic[31:0]Alu_out_E,load,PC_E;
    output logic[31:0]wdata;

    always_comb begin 
        case(wb_sel_E)
            2'b00:wdata = Alu_out_E;
            2'b01:wdata = load;
            2'b10:wdata = PC_E + 4;
        endcase
    end
endmodule

module Branch_Mux(sel_A,forwarded_A,PC_D,readData1);
    input logic[31:0]forwarded_A,PC_D;
    output logic[31:0]readData1;
    input logic sel_A;

    always_comb begin 
        case (sel_A)
            0: readData1 = forwarded_A;
            1: readData1 = PC_D; 
        endcase 
    end
endmodule

module Branch_taken(Alu_out,PC_br,br_taken,PC);
    input logic [31:0]Alu_out,PC;
    input logic br_taken;
    output logic [31:0] PC_br;
    always_comb begin 
        case (br_taken)
            0: PC_br = PC+4;
            1: PC_br = Alu_out; 
        endcase  
    end      
endmodule

module mux_forA(rdata1,Alu_out_E,for_A,forwarded_A);
    input logic [31:0]rdata1, Alu_out_E;
    input logic for_A;
    output logic[31:0] forwarded_A;
    always_comb begin 
        case (for_A)
            0: forwarded_A = rdata1;
            1: forwarded_A = Alu_out_E;  
        endcase
        
    end

endmodule
module mux_forB(rdata2,Alu_out_E,for_B,forwarded_B);
    input logic [31:0]rdata2, Alu_out_E;
    input logic for_B;
    output logic[31:0] forwarded_B;
    always_comb begin 
        case (for_B)
            0: forwarded_B = rdata2;
            1: forwarded_B = Alu_out_E;  
        endcase
        
    end

endmodule
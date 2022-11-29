module Data_memory(addrL,addrS,data_wr,data_rd,wr_E,clk,cs_E,mask);
    input logic[31:0]addrL,addrS,data_wr;
    output logic [31:0] data_rd;
    input logic wr_E,cs_E,clk;
    input logic[3:0] mask;

    logic [31:0] data_mem[0:255];
    initial begin
        $readmemb("Data_memory.txt",data_mem);
    end
    
    always_ff @( posedge clk ) begin
        data_rd = (~cs_E && ~wr_E) ? data_mem[addrL] : 0;
    end
    always_ff @( negedge clk ) begin
        if (~cs_E && wr_E)begin
            if (mask[0])begin
                data_mem[addrS][7:0] <= data_wr[7:0];
            end
            if (mask[1])begin
                data_mem[addrS][15:8] <= data_wr[15:8];
            end
            if (mask[2])begin
                data_mem[addrS][23:16] <= data_wr[23:16];
            end
            if (mask[3])begin
                data_mem[addrS][31:24] <= data_wr[31:24];
            end
        end        
    end
endmodule
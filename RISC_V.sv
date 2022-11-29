module RISC_V (clk,reset,out);
    input logic clk,reset;
    output logic [31:0]out;
    logic [31:0] rdata1,rdata2,Alu_out,Addr,instruction,wdata,PC,load,ST_W,LD_Byte,LD_UByte,LD_HW,LD_UHW,LD_W,addrL,sign_extended_I,data_wr,data_rd,readData2,ImmU,readData1,immB,ImmJ,PC_br,addrS,ImmS,PC_D,IR_D,PC_E,Alu_out_E,WD,IR_E,forwarded_A,forwarded_B,store;
    logic[6:0] opcode,fun7,opcode_E;
    logic[4:0] raddr1,raddr2,waddr;
    logic [2:0] fun3,fun3_E;
    logic alu_op,reg_wr,sel_B,cs,wr,sel_A,br_taken,for_A,for_B,reg_wr_E,wr_E,cs_E,stall,stallWM,Flush;
    logic [1:0] wb_sel,addr_dm,wb_sel_E;
    logic [3:0] mask;
    logic [7:0] ST_Byte;
    logic [15:0] ST_HByte;
    logic [11:0] immI;

    always_ff @( posedge clk ) begin 
        if (reset)begin
            PC <= 0;
        end        
        else if(~stall) begin
            PC <= PC_br;
        end
    end

    always_ff @( posedge clk ) begin 
        if (~stall)begin
            IR_D <= instruction;
            PC_D <= PC;
        end
    end

    always_ff @( posedge clk ) begin 
        if (~stallWM) begin
            PC_E      <= PC_D;
            Alu_out_E <= Alu_out;
            WD        <= forwarded_B;
            IR_E      <= IR_D;
            fun3_E    <= fun3;
            opcode_E  <= opcode;
        end
    end
    always_ff @( posedge clk ) begin 
        if (Flush)begin
            IR_D <= 0;
            // IR_E <= 0;
        end        
    end

    always_comb begin
        assign out = wdata;
        assign raddr1 = IR_D[19:15];
        assign raddr2 = IR_D[24:20];
        assign waddr  = IR_E[11:7] ;
        assign opcode = IR_D[6:0]  ;
        assign fun3   = IR_D[14:12];
        assign fun7   = IR_D[31:25];
        assign Addr   = PC[31:2];//(br_taken) ? PC : PC[31:2];    
        assign immI   = IR_D[31:20];   
        assign addrL  = (IR_E[6:0] == 7'b0000011) ? Alu_out_E : 0;
        assign ImmU   = {IR_D[31:12],12'b0};
        assign immB   = {{20{IR_D[31]}},{IR_D[7],IR_D[30:25],IR_D[11:8],1'b0}};
        assign ImmJ   = {{12{IR_D[31]}},{IR_D[19:12],IR_D[20],IR_D[30:21],1'b0}};
        assign ImmS   = {{20{IR_D[31]}}, IR_D[31:25], IR_D[11:7]};
        assign addrS  = (IR_E[6:0] == 7'b0100011) ? Alu_out_E : 0;
        assign addr_dm = addrS[1:0];
    end


    ALU AL(readData1,readData2,Alu_out,opcode,fun3,fun7,alu_op,ImmU,PC_D,ImmJ,sign_extended_I,immB,ImmS);
    controller CN(reset,alu_op,reg_wr,opcode,sel_B,wb_sel,cs,wr,sel_A,reg_wr_E,wr_E,cs_E ,wb_sel_E,clk);
    Data_memory DM(addrL,addrS,data_wr,data_rd,wr_E,clk,cs_E,mask);
    instruction_memory IM(Addr,instruction);
    register_file RF(raddr1,raddr2,waddr,wdata,rdata1,rdata2,clk,reg_wr_E);
    mux_I I_Type(sel_B,forwarded_B,sign_extended_I,readData2);
    signed_extension SE(immI,sign_extended_I,opcode);
    Ld_St_unit LSU(opcode_E,fun3_E,load,store,LD_Byte,LD_UByte,LD_HW,LD_UHW,LD_W,ST_Byte,ST_HByte,ST_W);
    LD_Sizing LDS(opcode_E,fun3_E,addr_dm,LD_Byte,LD_HW,LD_W,data_rd,LD_UByte,LD_UHW);
    ST_Sizing STS(opcode_E,fun3_E,mask,data_wr,WD,addr_dm,ST_Byte,ST_HByte,ST_W);
    mux_LS mxLS(wb_sel_E,Alu_out_E,load,wdata,PC_E);
    Branch_Mux Br_M(sel_A,forwarded_A,PC_D,readData1);
    Branch_taken Br_tk(Alu_out,PC_br,br_taken,PC);
    Branch Br(forwarded_A,forwarded_B,br_taken,opcode,fun3);
    mux_forA forA(rdata1,Alu_out_E,for_A,forwarded_A);
    mux_forB forB(rdata2,Alu_out_E,for_B,forwarded_B);
    Hazard_Unit HZU(IR_D,IR_E,for_A,for_B,reg_wr_E,stall,stallWM,wb_sel_E,br_taken,Flush);
endmodule
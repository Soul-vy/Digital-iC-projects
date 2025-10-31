module DSP #(parameter
A0REG=0,A1REG=1,B0REG=0,B1REG=1,
CREG=1,DREG=1,MREG=1,PREG=1,
CARRYINREG=1,CARRYOUTREG=1,OPMODEREG=1,
CARRYINSEL="OPMODE5",
B_INPUT="DIRECT",
RSTTYPE="SYNC"
) 
(  // #Input & Output

input [17:0] A,B,D,
input [47:0] C,
input [47:0] PCIN,
input [17:0] BCIN,
input CARRYIN,
input clk,
input [7:0] opmode,
input RSTA,RSTB,RSTC,RSTD,RSTM,RSTP,
input RSTOPMODE,RSTCARRYIN,
input CEA,CEB,CEC,CED,CEM,CEP,
input CEOPMODE,CECARRYIN,

output CARRYOUT,CARRYOUTF,
output [35:0] M,
output [47:0] P,
output [17:0] BCOUT,
output [47:0] PCOUT
  
);
wire signed [17:0] A0_out,B0_out,A1_out,B1_out,D_out,B0_in,Pre,B1_in;
wire [35:0] Multi;
wire [47:0] C_out,Post;
wire Carry,Cin,Cout;
wire [7:0] OP;
reg [47:0] X,Z;

DSP_MOD #(.n(18),.RSTTYPE(RSTTYPE),.Reg(A0REG))        A0  (.in(A),.out(A0_out),.clk(clk),.rstn(RSTA),.en(CEA));
DSP_MOD #(.n(18),.RSTTYPE(RSTTYPE),.Reg(B0REG))        B0  (.in(B0_in),.out(B0_out),.clk(clk),.rstn(RSTB),.en(CEB));
DSP_MOD #(.n(18),.RSTTYPE(RSTTYPE),.Reg(A1REG))        A1  (.in(A0_out),.out(A1_out),.clk(clk),.rstn(RSTA),.en(CEA));
DSP_MOD #(.n(18),.RSTTYPE(RSTTYPE),.Reg(B1REG))        B1  (.in(B1_in),.out(B1_out),.clk(clk),.rstn(RSTB),.en(CEB));
DSP_MOD #(.n(18),.RSTTYPE(RSTTYPE),.Reg(DREG))         Dinst (.in(D),.out(D_out),.clk(clk),.rstn(RSTD),.en(CED));
DSP_MOD #(.n(48),.RSTTYPE(RSTTYPE),.Reg(CREG))       Cinst (.in(C),.out(C_out),.clk(clk),.rstn(RSTC),.en(CEC));
DSP_MOD #(.n(48),.RSTTYPE(RSTTYPE),.Reg(PREG))       Pinst  (.in(Post),.out(P),.clk(clk),.rstn(RSTP),.en(CEP));
DSP_MOD #(.n(36),.RSTTYPE(RSTTYPE),.Reg(MREG))       Minst (.in(Multi),.out(M),.clk(clk),.rstn(RSTM),.en(CEM));
DSP_MOD #(.n(1),.RSTTYPE(RSTTYPE),.Reg(CARRYINREG))  CYI (.in(Carry),.out(Cin),.clk(clk),.rstn(RSTCARRYIN),.en(CECARRYIN));
DSP_MOD #(.n(1),.RSTTYPE(RSTTYPE),.Reg(CARRYOUTREG)) CYO (.in(Cout),.out(CARRYOUT),.clk(clk),.rstn(RSTCARRYIN),.en(CECARRYIN));
DSP_MOD #(.n(8),.RSTTYPE(RSTTYPE),.Reg(OPMODEREG))   OPMODE (.in(opmode),.out(OP),.clk(clk),.rstn(RSTOPMODE),.en(CEOPMODE));

assign Carry=(CARRYINSEL=="OPMODE5") ? OP[5] : (CARRYINSEL=="CARRYIN") ? CARRYIN : 1'b0 ;
assign B0_in=(B_INPUT=="DIRECT") ? B : (B_INPUT=="CASCADE") ? BCIN : 18'b0 ;

always @(*) begin 
  case (OP[1:0])
    0: X=48'b0;
    1: X={12'b0,M};
    2: X=P;
    3: X={D_out[11:0],A1_out,B1_out};
    default: X=48'b0; 
  endcase
end

always @(*) begin 
  case (OP[3:2])
    0: Z=48'b0;
    1: Z=PCIN;
    2: Z=P;
    3: Z=C_out; 
    default: Z=48'b0; 
  endcase
end

assign CARRYOUTF=CARRYOUT;
assign BCOUT=B1_out;
assign PCOUT=P;
assign Multi=A1_out*B1_out;
assign {Cout,Post}= OP[7] ? Z-(X+Cin) : Z+X+Cin;
assign B1_in= OP[4] ?  Pre : B0_out;
assign Pre= OP[6] ? D_out-B0_out : D_out+B0_out ;

endmodule //DSP

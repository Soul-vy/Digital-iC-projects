module DSP_tb (    
);

localparam A0REG=0,A1REG=1,B0REG=0,B1REG=1,CREG=1,DREG=1,MREG=1,PREG=1,CARRYINREG=1,CARRYOUTREG=1,OPMODEREG=1;
localparam CARRYINSEL="OPMODE5",B_INPUT="DIRECT",RSTTYPE="SYNC";

reg signed [17:0] A,B,D;
reg [47:0] C;
reg [47:0] PCIN;
reg [17:0] BCIN;
reg CARRYIN;
reg clk;
reg [7:0] opmode;
reg RSTA,RSTB,RSTC,RSTD,RSTM,RSTP;
reg RSTOPMODE,RSTCARRYIN;
reg CEA,CEB,CEC,CED,CEM,CEP;
reg CEOPMODE,CECARRYIN;
wire CARRYOUT,CARRYOUTF;
wire [35:0] M;
wire signed [47:0] P;
wire [17:0] BCOUT;
wire [47:0] PCOUT;

DSP #(
.A0REG(A0REG),
.A1REG(A1REG),
.B0REG(B0REG),
.B1REG(B1REG),
.CREG(CREG),
.DREG(DREG),
.MREG(MREG),
.PREG(PREG),
.CARRYINREG(CARRYINREG),
.CARRYOUTREG(CARRYOUTREG),
.OPMODEREG(OPMODEREG), 
.CARRYINSEL(CARRYINSEL),
.B_INPUT(B_INPUT),
.RSTTYPE(RSTTYPE)   
) IC (.*);

initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end

initial begin
    
RSTA = 1'b1;
RSTB = 1'b1;
RSTC = 1'b1;
RSTD = 1'b1;
RSTM = 1'b1;
RSTP = 1'b1;
RSTOPMODE = 1'b1;
RSTCARRYIN = 1'b1;
A=18'd1;
B=18'd1;
D=18'd1;
C=48'd1;
PCIN=48'b1;
BCIN=18'b1;
CARRYIN=1'b1;
CEA=1'b1;
CEB=1'b1;
CEC=1'b1;
CED=1'b1;
CEM=1'b1;
CEP=1'b1;
CEOPMODE=1'b1;
CECARRYIN=1'b1;
opmode=8'b1;

repeat (1) @(negedge clk);

RSTA =1'b0;
RSTB =1'b0;
RSTC =1'b0;
RSTD =1'b0;
RSTM =1'b0;
RSTP =1'b0;
RSTOPMODE =1'b0;
RSTCARRYIN =1'b0;

if(P!==0 || M!==0 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

/// OP 8'b00000000 \\\

opmode=8'b00000000;

A=18'd5;
B=18'd6;
D=18'd7;
C=48'd8;

repeat (1) @(negedge clk);
if(P!==0 || M!==0 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

/// Random Check #1 \\\
opmode=8'b01011101;

A=18'd5;
B=18'd6;
D=18'd7;
C=48'd8;

repeat (5) @(negedge clk);

if(P!==13 || M!==5 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

/// Random Check #2 \\\
opmode=8'b11011101;

A=18'd2;
B=18'd20;
D=18'd45;
C=48'd120;

repeat (5) @(negedge clk);

if(P!==70 || M!==50 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

/// Random Check #3 \\\
opmode=8'b01010000;

A=18'd2;
B=18'd2;
D=18'd4;
C=48'd120;

repeat (5) @(negedge clk);

if(P!==0 || M!==4 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

/// Random Check #4 \\\
opmode=8'b01111010;

A=18'd2;
B=18'd2;
D=18'd4;
C=48'd120;

repeat (5) @(negedge clk);

if(P!==7 || M!==4 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

/// Random Check #5 \\\
opmode=8'b01100101;

A=18'd2;
B=18'd30;
D=18'd300;
C=48'd3000;

repeat (5) @(negedge clk);

if(P!==62 || M!==60 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

/// Random Check #6 \\\
opmode=8'b01001111;

A=18'd0;
B=18'd1;
D=18'd0;
C=48'd6;

repeat (5) @(negedge clk);

if(P!==7 || M!==0 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

/// 8'b11111111 \\\
opmode=8'b11111111;

A=18'd0;
B=18'd0;
D=18'd0;
C=48'd8;

repeat (5) @(negedge clk);

if(P!==7 || M!==0 || CARRYOUT!==0 ) begin
 $display("ERROR");
 $stop;
end

$display("Test completed successfuly");
$stop;

end

initial begin
   $monitor ("A=%d ,B=%d ,C=%d ,D=%d ,opmode=%b ,M=%d ,P=%d , CARRYIN=%d ,CARRYOUT=%d ",A ,B ,C ,D ,opmode ,M ,P ,CARRYIN ,CARRYOUT); 
end 

endmodule //DSP_tb


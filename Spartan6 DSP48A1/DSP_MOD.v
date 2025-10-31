module DSP_MOD #( parameter n=18 ,RSTTYPE="SYNC",Reg=0)(
    input [n-1:0] in,
    input clk,rstn,en,
    output [n-1:0] out
);

 reg [n-1:0] Seq;

generate

if(RSTTYPE=="ASYNC") begin

always @(posedge clk ,posedge rstn) begin
    if(rstn)
    Seq<=0;
    else  
    if(en)
    Seq<=in;    
end
end

else begin

always @(posedge clk) begin
    if(rstn)
    Seq<=0;
    else  
    if(en)
    Seq<=in;    
end
end

endgenerate

assign out= Reg ? Seq :in ;


endmodule //DSP_MOD

module ALSU_tb (
);

localparam Priority="A";
localparam Adder="ON";
localparam Turn=350; // param for the total loop turns

reg clk,rstn;
reg [2:0] A,B;
reg cin;
reg serial,direction;
reg op_A,op_B;
reg [2:0] opcode;
reg bypass_A,bypass_B;

wire [15:0] leds;
wire [5:0] out;

reg [5:0] Q_exp;

ALSU #(.Priority(Priority),.Adder(Adder)) A1( 
.clk(clk),
.rstn(rstn),
.A(A),
.B(B),
.cin(cin),
.serial(serial),
.direction(direction),
.op_A(op_A),
.op_B(op_B),
.opcode(opcode),
.bypass_A(bypass_A),
.bypass_B(bypass_B),
.leds(leds),
.out(out)
);

initial begin 
    clk=0;
    forever begin
        #10 clk=~clk;
    end
end

integer i;

initial begin
    rstn=1;
    A=0;
    B=0;
    cin=0;
    serial=0;
    direction=0;
    op_A=0;
    op_B=0;
    opcode=0;
    bypass_A=0;
    bypass_B=0;
    @(negedge clk);
    @(negedge clk);
    // self checking 
    if((out!=0) || (leds!=0)) begin
    $display("ERROR");
    $stop;
    end
    
    rstn=0;

    for(i=0;i<Turn;i=i+1) begin    
    A=$random;
    B=$random;
    if((Turn/7)*1>i) begin // bypass verify
    bypass_A=1;
    bypass_B=1;
    opcode=$urandom_range(0,7);
    Q_exp=A;
    if (i>20 && i<30) begin // led blinking verify
    opcode=7;
    bypass_A=0;
    bypass_B=0;
    Q_exp=0;
    end
    end
    else if((Turn/7)*2>i) begin // And gate & red_op verify
    bypass_A=0;
    bypass_B=0;
    opcode=0;
    op_A=$random;
    op_B=$random;
    if (op_A&&op_B) 
    Q_exp=&A;
    else if (op_A)
    Q_exp=&A;
    else if (op_B)
    Q_exp=&B;
    else 
    Q_exp=A&B;
    end
    else if((Turn/7)*3>i) begin // Xor gate & red_op verify
    bypass_A=0;
    bypass_B=0;
    opcode=1;
    op_A=$random;
    op_B=$random;
    if (op_A&&op_B) 
    Q_exp=^A;
    else if (op_A)
    Q_exp=^A;
    else if (op_B)
    Q_exp=^B;
    else 
    Q_exp=A^B; 
    end
    else if((Turn/7)*4>i) begin // Addition verify
    bypass_A=0;
    bypass_B=0;
    opcode=2;
    op_A=0;
    op_B=0;
    cin=$random;
    Q_exp=A+B+cin;
    end
    else if((Turn/7)*5>i) begin // multiply verfiy
    bypass_A=0;
    bypass_B=0;
    opcode=3;
    op_A=0;
    op_B=0;
    cin=0;
    Q_exp=A*B;
    end
    else if((Turn/7)*6>i) begin // shift verfiy
    bypass_A=0;
    bypass_B=0;
    opcode=4;
    op_A=0;
    op_B=0;
    cin=0;
    serial=$random;    
    //Q_exp={serial,Q_exp[5:1]};
    end
    else if((Turn/7)*7>i) begin // rotate verfiy
    bypass_A=0;
    bypass_B=0;
    opcode=5;
    op_A=0;
    op_B=0;
    cin=0;
    direction=$random;
    /*
    if(direction)
    Q_exp<={Q_exp[0],Q_exp[5:1]};
    else
    Q_exp<={Q_exp[4:0],Q_exp[5]};
    */
    end
    // two edge clk wait for registers
    @(negedge clk);
    @(negedge clk);

    // self checking 
    if(out!=Q_exp && i<250) begin
    $display("ERROR in Turn=%d",i);
    $stop;
    end

    end
    
   $display("Test completed successfuly");
   $stop;

end

initial begin

    $monitor ("rstn=%b ,A=%b ,B=%b ,opcode=%b ,cin=%b ,serial=%b ,direction=%b, op_A=%b ,op_B=%b ,bypass_A=%b ,bypass_B=%b ,out=%b ,leds=%b",rstn ,A ,B ,opcode ,cin ,serial ,direction , op_A ,op_B ,bypass_A ,bypass_B ,out ,leds); 

end 
endmodule //ALSU_tb

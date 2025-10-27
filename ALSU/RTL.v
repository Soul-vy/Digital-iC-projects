

module ALSU #(parameter Priority="A",Adder="ON")(
    input clk,rstn,
    input [2:0] A,B,
    input cin,
    input serial,direction,
    input op_A,op_B,
    input [2:0] opcode,
    input bypass_A,bypass_B,

    output reg [15:0] leds,
    output reg [5:0] out
);

reg [2:0] A_reg,B_reg;
reg [2:0] opcode_reg;
reg serial_reg,direction_reg;
reg op_A_reg,op_B_reg;
reg bypass_A_reg,bypass_B_reg;
reg cin_reg;
reg [5:0] out_reg;
reg [15:0] leds_reg;

wire [5:0] out_shift,out_circ;

 Shift_reg_ALSU #(.n()) S1
 (
 .clk(clk),
 .rstn(rstn),
 .direction(direction),
 .serial(serial),
 .Q(out_shift)
 );

 Circ_shift_reg #(.n()) C1
 (
 .clk(clk),
 .rstn(rstn),
 .direction(direction),
 .Q(out_circ)
 );

always @(posedge clk or posedge rstn) begin
    if(rstn) begin
    out<=0;
    leds<=0;
    leds_reg<=0;
    end 
    else begin 
    A_reg<=A;
    B_reg<=B;
    op_A_reg<=op_A;
    op_B_reg<=op_B;
    serial_reg<=serial;
    direction_reg<=direction;
    opcode_reg<=opcode;
    bypass_A_reg<=bypass_A;
    bypass_B_reg<=bypass_B;
    cin_reg<=cin;

    out<=out_reg;
    leds<=leds_reg;

    end       
end

always @(*) begin
    if (bypass_A_reg&&bypass_B_reg) begin
    if (Priority== "A")
      out_reg=A;
    else
      out_reg=B;
    end  
    else if(bypass_A_reg)
    out_reg=A;
    else if (bypass_B_reg)
    out_reg=B;
    else begin
    if (leds_reg && opcode<6)  
    leds_reg=0;  
    case (opcode_reg)
        0: begin
           if (op_A_reg&&op_B_reg) begin
           if (Priority== "A")
           out_reg=&A;
           else
           out_reg=&B;
           end 
           else if (op_A_reg)
           out_reg=&A;
           else if (op_B_reg)
           out_reg=&B;
           else 
           out_reg=A_reg&B_reg;
        end
        1: begin
           if (op_A_reg&&op_B_reg) begin
           if (Priority== "A")
           out_reg=^A;
           else
           out_reg=^B;
           end 
           else if (op_A_reg)
           out_reg=^A;
           else if (op_B_reg)
           out_reg=^B;
           else 
           out_reg=A_reg^B_reg;
        end   
        2: begin
           if (Adder== "ON")
           out_reg=A_reg+B_reg+cin_reg;
           else
           out_reg=A_reg+B_reg;
        end
        3: out_reg=A_reg*B_reg;
        4: out_reg=out_shift;
        5: out_reg=out_circ; 
        default:  begin
           leds_reg=~leds_reg;
           out_reg=0;
        end                     
    endcase
    end
end

endmodule //ALSU

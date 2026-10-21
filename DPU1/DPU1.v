module DPU1(
input clk,
input x,
output reg z
);
reg [3:0]y=4'd0;
always @(posedge clk)begin
y<={y[2:0],x};
case(y) 
4'd2: z<=1'b1;
4'd4: z<=1'b1;
4'd5: z<=1'b1;
4'd8: z<=1'b1;
4'd14: z<=1'b1;
default: z<=1'b0;
endcase
end
endmodule

//TESTBENCH
module DPU1_tb;
reg clk=1'b0;
reg x;
reg [18:0]X=19'b0000101001000100111;
wire z;
always #5 clk=~clk;
integer i;
DPU1 uut(.clk(clk),.x(x),.z(z));
initial begin
for(i=0;i<19;i=i+1) begin
x<=X[18-i]; #10;
end
#10;
$finish;
end
endmodule

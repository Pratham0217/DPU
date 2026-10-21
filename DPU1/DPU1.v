module DPU1(
input clk,        // Clock 
input x,          // Input
output reg z      // Output
);
reg [3:0]y=4'd0;        //4-bit register to store the previous 3 inputs and the current input
always @(posedge clk)begin
// Shift left by 1 bit and store the new input 'x' in the LSB.
// This is done everytime a new input is given, i.e. at every posedge of the clk.
y<={y[2:0],x};
  case(y)         // Checks if the given conditions are satisfied
4'd2: z<=1'b1;    // Checks if y=0010
4'd4: z<=1'b1;    // Checks if y=0100
4'd5: z<=1'b1;    // Checks if y=0101
4'd8: z<=1'b1;    // Checks if y=1000
4'd14: z<=1'b1;   // Checks if y=1110
default: z<=1'b0; // If no value is matched, then output is 0
endcase
end
endmodule

//TESTBENCH
module DPU1_tb;
reg clk=1'b0;
reg x;
// 19-bit input which was given in the PDF
reg [18:0]X=19'0010100100010111010;
wire z;
// Clock signal of period 10 units
always #5 clk=~clk;
integer i;
// Instantiating uut and connecting the ports
DPU1 uut(.clk(clk),.x(x),.z(z));
initial begin
// Loop through the 19-bit input, sending one bit per clock cycle
for(i=0;i<19;i=i+1) begin
// Inputs bits starting from the MSB to the LSB
x<=X[18-i]; #10;
// Wait for one full clock cycle before sending the next bit
end
end
#10;
$finish;
end
endmodule

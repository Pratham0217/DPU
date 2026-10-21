module FSM(
input [7:0]byte,    // 8-bit input
input clk,          // Clock
output reg signal   // Output signal
);
// 2-bit register used as the state variable for the FSM. 
// States: 0 (Wait), 1 (Byte 2 received), 2 (Byte 3 received)
reg [1:0]i=2'd0;
always @(posedge clk) begin
// Signal is low unless we get the 3 byte message
signal<=0;
case(i) 
// State 0
2'd0: 
  // Check if byte[3] = 1. This acts as the "Start of Message" trigger.
if(byte[3])
i<=2'd1; // Move to State 1 to process the next byte
// State 1
2'd1: 
// Moves to State 2 after receiving byte 2
i<=2'd2;
// State 2
2'd2: begin
i<=2'd0;    // Reset back to State 0 to wait for the next message
signal<=1;  // Assert the signal high to indicate a full 3-byte message was received
end
default:
i<=2'd0;
endcase
end
endmodule

// Testbench
module FSM_tb;
  reg [7:0] tb_byte; // Input
reg clk;
wire tb_signal;  // Output
// Instantiate the uut
FSM uut (.byte(tb_byte),.clk(clk), .signal(tb_signal));
// Clock generation (10 time units period)
always #5 clk = ~clk;
initial begin
// Initialize Inputs
clk = 0;
tb_byte = 0;
// TEST 1: Invalid bytes before a message
@(posedge clk);
tb_byte = 8'b0000_0000; // bit[3] = 0
@(posedge clk);
tb_byte = 8'b0000_0111; // bit[3] = 0 
@(posedge clk);
// TEST 2: First Valid Message (3 bytes)
tb_byte = 8'b0000_1000; // Byte 1: bit[3] = 1 (Starts message)
@(posedge clk);
tb_byte = 8'b1111_0000; // Byte 2: bit[3] = 0
@(posedge clk);
  tb_byte = 8'b1010_1010; // Byte 3: bit[3] = 1 (Signal=1 next posedge of the clk)
@(posedge clk);
// TEST 3: Consecutive Message
tb_byte = 8'b0000_1100; // Byte 1: bit[3] = 1 (Starts new message)
@(posedge clk);
tb_byte = 8'b1100_1100; // Byte 2: bit[3] = 1
@(posedge clk);
tb_byte = 8'b0011_0011; // Byte 3: bit[3] = 0
@(posedge clk);
// TEST 4: Gaps between messages (Invalid bytes acting as gaps)
tb_byte = 8'b0000_0000; // Gap byte (bit[3] = 0)
@(posedge clk);
tb_byte = 8'b0000_0011; // Gap byte (bit[3] = 0)
@(posedge clk);
// TEST 5: Another valid message after the gap
tb_byte = 8'b1111_1111; // Byte 1: bit[3] = 1 
@(posedge clk);
tb_byte = 8'b0000_0000; // Byte 2: bit[3] = 0
@(posedge clk);
tb_byte = 8'b1111_0000; // Byte 3: bit[3] = 0
@(posedge clk);
#20;
$finish;
end
endmodule

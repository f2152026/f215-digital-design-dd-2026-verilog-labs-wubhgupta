// alu.v
// 1-bit-opcode ALU: op=0 -> add, op=1 -> sub. 4-bit operands.
// Subtraction is implemented the way real hardware does it: negate b (one's
// complement, then +1 for two's complement) and add.
//
// FIXES:
//   1. Sensitivity list: was @(a, b), so a change in op alone never re-ran the
//      block. Now @(a, b, op)  (specific signals, not @*).
//   2. Subtract path: the three dependent steps used non-blocking (<=), so each
//      step saw the OLD value of the one before it. They are now blocking (=),
//      so b_inv -> b_twos -> result evaluate in order within the same block.

module alu (
  input      [3:0] a,
  input      [3:0] b,
  input            op,      // 0 = add, 1 = sub
  output reg [3:0] result
);

  reg [3:0] b_inv;
  reg [3:0] b_twos;

  always @(a, b, op) begin
    case (op)
      1'b0: begin
        result = a + b;                 // add
      end
      1'b1: begin
        b_inv  = ~b;                    // sub, via two's complement
        b_twos = b_inv + 1;
        result = a + b_twos;
      end
    endcase
  end

endmodule

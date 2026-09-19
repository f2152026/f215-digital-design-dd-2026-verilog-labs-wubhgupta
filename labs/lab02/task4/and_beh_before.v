// and_beh_before.v -- 2-input AND, BEHAVIORAL style, delay BEFORE the assignment.
// The statement waits, then evaluates a & b using the values at the LATER time.
// Delay defaults to 1; override at compile time with:  iverilog -DDELAY=2 ...
`ifndef DELAY
  `define DELAY 1
`endif

module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    #`DELAY y = a & b;
  end

endmodule

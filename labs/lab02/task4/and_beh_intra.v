// and_beh_intra.v -- 2-input AND, BEHAVIORAL style, INTRA-assignment delay.
// a & b is evaluated immediately; only the write into y is delayed.
// Delay defaults to 1; override at compile time with:  iverilog -DDELAY=2 ...
`ifndef DELAY
  `define DELAY 1
`endif

module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    y = #`DELAY a & b;
  end

endmodule

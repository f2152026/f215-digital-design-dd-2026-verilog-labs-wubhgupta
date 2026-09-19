// and_df.v -- 2-input AND, DATAFLOW style with a delay on the continuous assign.
// Delay defaults to 1; override at compile time with:  iverilog -DDELAY=2 ...
`ifndef DELAY
  `define DELAY 1
`endif

module and_df (
  input  a,
  input  b,
  output y
);

  assign #`DELAY y = a & b;

endmodule

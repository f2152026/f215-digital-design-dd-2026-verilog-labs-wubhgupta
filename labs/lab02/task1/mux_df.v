// mux_df.v
// 2-to-1 multiplexer, DATAFLOW style.
//
// FIX: a continuous assignment (assign) can only drive a NET. Y was declared
// "output reg", which is a variable, so it was illegal on the left of assign.
// Y is now an "output wire".

module mux_df (
  input       I0,
  input       I1,
  input       S,
  output wire Y
);

  assign Y = S ? I1 : I0;

endmodule

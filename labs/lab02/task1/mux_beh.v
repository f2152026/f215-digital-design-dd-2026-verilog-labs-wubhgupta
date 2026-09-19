// mux_beh.v
// 2-to-1 multiplexer, BEHAVIORAL style.
//
// FIX: a procedural assignment (inside always/initial) can only drive a
// VARIABLE (reg). Y was declared "output wire", which is a net, so it was
// illegal on the left of "=" inside always. Y is now an "output reg".

module mux_beh (
  input      I0,
  input      I1,
  input      S,
  output reg Y
);

  always @(*) begin
    if (S)
      Y = I1;
    else
      Y = I0;
  end

endmodule

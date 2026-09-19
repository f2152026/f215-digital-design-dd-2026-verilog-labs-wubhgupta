// comp2.v
// 2-bit unsigned magnitude comparator.
// Given two 2-bit values A and B, exactly one of GT, LT, EQ is 1
// for any input combination.
//
// FIX: GT used ">=" so it was also 1 whenever A == B (where EQ is 1 too).
// It must be a strict ">".

module comp2 (
  input  [1:0] A,
  input  [1:0] B,
  output       GT,
  output       LT,
  output       EQ
);

  assign EQ = (A == B);
  assign GT = (A >  B);
  assign LT = (A <  B);

endmodule

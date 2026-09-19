// tb.v
// Self-checking testbench for comp2 (2-bit magnitude comparator).
// Expected outputs are computed independently from integer copies of A and B.

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer i, j;
  integer errors, total;
  integer ia, ib;
  reg     exp_gt, exp_lt, exp_eq;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  initial begin
    errors = 0;
    total  = 0;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;

        // Independent reference model using plain integers
        ia = i;
        ib = j;
        exp_gt = (ia > ib);
        exp_lt = (ia < ib);
        exp_eq = (ia == ib);

        #5;
        total = total + 1;

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    $write("comp2 summary: %0d of %0d combinations passed", total - errors, total);
    if (errors == 0) $write("  -- ALL PASS");
    $write("\n");
    $finish;
  end

endmodule

// tb.v
// Self-checking testbench for alu (op=0: a+b, op=1: a-b, 4-bit result).
//
// Part 1: same operand pair held fixed while op is switched (add <-> sub).
//         Exposes a sensitivity-list bug (result must respond to op).
// Part 2: operands change, for both ops (exhaustive: all a, b, op).
//         Exposes a blocking / non-blocking bug in the subtract chain.
//
// Expected values are computed independently in the testbench.

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  integer i, j, k;
  integer errors, total;
  reg [3:0] expected;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  // Apply the current t_a/t_b/t_op, wait, and compare with a+b or a-b (mod 16)
  task check;
    begin
      #5;
      expected = t_op ? (t_a - t_b) : (t_a + t_b);
      total = total + 1;
      if (t_result !== expected) begin
        $display("FAIL at time %0t: a=%0d b=%0d op=%b  got %0d  expected %0d",
                 $time, t_a, t_b, t_op, t_result, expected);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    total  = 0;

    // ---- Part 1: fixed operands, switch op back and forth ----
    t_a = 4'd9; t_b = 4'd3;
    t_op = 0; check;   // 9 + 3 = 12
    t_op = 1; check;   // 9 - 3 = 6   (only op changed)
    t_op = 0; check;   // back to add (only op changed)
    t_op = 1; check;   // and to sub again

    t_a = 4'd5; t_b = 4'd7;
    t_op = 1; check;   // 5 - 7 = -2 -> 14 (wraps)
    t_op = 0; check;

    // ---- Part 2: operands change, exhaustive over a, b, op ----
    for (k = 0; k < 2; k = k + 1)
      for (i = 0; i < 16; i = i + 1)
        for (j = 0; j < 16; j = j + 1) begin
          t_op = k;
          t_a  = i;
          t_b  = j;
          check;
        end

    $write("alu summary: %0d of %0d checks passed", total - errors, total);
    if (errors == 0) $write("  -- ALL PASS");
    $write("\n");
    $finish;
  end

endmodule

// tb.v
// Self-checking testbench for the parameterized ROM (lut).
// Overrides the module defaults (WIDTH=8, DEPTH=4) with DEPTH=8.

module tb;

  localparam WIDTH = 8;
  localparam DEPTH = 8;

  reg  [2:0]       t_sel;    // 3 bits covers DEPTH = 4 and DEPTH = 8
  wire [WIDTH-1:0] t_dout;

  integer i;
  integer errors;
  reg [WIDTH-1:0] expected;

  // Parameter override at instantiation. Instance named DUT so that
  // $dumpvars(0, DUT) below resolves to it.
  lut #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    t_sel  = 0;
    #5;   // let the ROM's initial block finish

    // Loop sel through every valid address and check against i*i
    for (i = 0; i < DEPTH; i = i + 1) begin
      t_sel    = i;
      expected = i * i;
      #5;
      if (t_dout !== expected) begin
        $display("FAIL at time %0t: sel=%0d got %0d expected %0d",
                 $time, t_sel, t_dout, expected);
        errors = errors + 1;
      end
    end

    $write("lut test: %0d of %0d addresses passed", DEPTH - errors, DEPTH);
    if (errors == 0) $write("  -- ALL PASS");
    $write("\n");
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule

`timescale 1us/1us
module TopLevel(
    input reset,
    input clock
);

    MIPS dut (
        .clk(clock),
        .rst(reset)
    );

endmodule

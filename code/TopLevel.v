module TopLevel(
    input reset,
    input clock
);

    MIPS dut (
        .clk(clock),
        .rst(reset)
    );

endmodule

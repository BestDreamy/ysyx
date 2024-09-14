`define PIPE_INST(PARAM, signal, __lhp, __mbp, __rhp)     \
    pipe #(                                               \
        .DATA_WIDTH(PARAM)                                \
    ) signal``_pipe (                                     \
        .clk        (clk_i),                              \
        .rst        (rst_i),                              \
        .pin_valid  (__lhp``_valid_i),                    \
        .pin_data   (__lhp``_``signal``_i),               \
        .pin_ready  (__mbp``_ready_o),                    \
        .pout_valid (__mbp``_valid_o),                    \
        .pout_data  (__rhp``_``signal``_o),               \
        .pout_ready (__rhp``_ready_i)                     \
    );
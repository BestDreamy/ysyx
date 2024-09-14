`define PIPE_INST (PARAM)(INST_NAME)(__lhp, __mbp, __rhp) \
    pipe #(                                               \
        .DATA_WIDTH(PARAM)                                \
    ) INST_NAME (                                         \
        .clk        (clk_i),                              \
        .rst        (rst_i),                              \
        .pin_valid  (__lhp``_valid_i),                    \
        .pin_data   (__lhp``_opinfo_i),                   \
        .pin_ready  (__mbp``_ready_o),                    \
        .pout_valid (__mbp``_valid_o),                    \
        .pout_data  (__rhp``_opinfo_o),                   \
        .pout_ready (__rhp``_ready_i)                     \
    );
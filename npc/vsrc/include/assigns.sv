// `define PIPE_INST(PARAM, signal, __lhp, __mbp, __rhp)     \
//     pipe #(                                               \
//         .DATA_WIDTH(PARAM)                                \
//     ) signal``_pipe (                                     \
//         .clk        (clk_i),                              \
//         .rst        (rst_i),                              \
//         .pin_valid  (__lhp``_valid_i),                    \
//         .pin_data   (__lhp``_``signal``_i),               \
//         .pin_ready  (__mbp``_ready_o),                    \
//         .pout_valid (__mbp``_valid_o),                    \
//         .pout_data  (__rhp``_``signal``_o),               \
//         .pout_ready (__rhp``_ready_i)                     \
//     );

// The direction of left hand according to valid.
`define AXI_ASSIGN_AR(lhp__, lh_sep, __lhs, rhp__, rh_sep, __rhs)              \
    assign lhp__``ar``lh_sep``valid``__lhs = rhp__``ar``rh_sep``valid``__rhs;  \
    assign lhp__``ar``lh_sep``data``__lhs  = rhp__``ar``rh_sep``data``__rhs;   \
    assign lhp__``ar``lh_sep``ready``__lhs = rhp__``ar``rh_sep``ready``__rhs;  

`define AXI_ASSIGN_R(lhp__, lh_sep, __lhs, rhp__, rh_sep, __rhs)               \
    assign lhp__``r``lh_sep``valid``__lhs = rhp__``r``rh_sep``valid``__rhs;    \
    assign lhp__``r``lh_sep``data``__lhs  = rhp__``r``rh_sep``data``__rhs;     \
    assign lhp__``r``lh_sep``resp``__lhs  = rhp__``r``rh_sep``resp``__rhs;     \
    assign lhp__``r``lh_sep``ready``__lhs = rhp__``r``rh_sep``ready``__rhs;    

`define AXI_ASSIGN_AW(lhp__, lh_sep, __lhs, rhp__, rh_sep, __rhs)               \
    assign lhp__``aw``lh_sep``valid``__lhs = rhp__``aw``rh_sep``valid``__rhs;   \
    assign lhp__``aw``lh_sep``addr``__lhs  = rhp__``aw``rh_sep``addr``__rhs;    \
    assign rhp__``aw``rh_sep``ready``__lhs = lhp__``aw``lh_sep``ready``__rhs;   

`define AXI_ASSIGN_W(lhp__, lh_sep, __lhs, rhp__, rh_sep, __rhs)               \
    assign lhp__``w``lh_sep``valid``__lhs = rhp__``w``rh_sep``valid``__rhs;    \
    assign lhp__``w``lh_sep``data``__lhs  = rhp__``w``rh_sep``data``__rhs;     \
    assign lhp__``w``lh_sep``strb``__lhs  = rhp__``w``rh_sep``strb``__rhs;     \
    assign rhp__``w``rh_sep``ready``__lhs = lhp__``w``lh_sep``ready``__rhs;    

`define AXI_ASSIGN_B(lhp__, lh_sep, __lhs, rhp__, rh_sep, __rhs)               \
    assign lhp__``b``lh_sep``valid``__lhs = rhp__``b``rh_sep``valid``__rhs;    \
    assign lhp__``b``lh_sep``resp``__lhs  = rhp__``b``rh_sep``resp``__rhs;     \
    assign rhp__``b``rh_sep``ready``__lhs = lhp__``b``lh_sep``ready``__rhs;    

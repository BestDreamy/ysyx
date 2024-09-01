interface axi_if;
  parameter int ADDR_W = 32;
  parameter int DATA_W = 32;
//   parameter ID_W   = 4;
//   parameter USER_W = 1;

  localparam int STRB_W = DATA_W / 8;

  logic                   ar_ready  ;
  logic                   ar_valid  ;
  logic   [ADDR_W-1:0]    ar_addr   ;

  logic   [DATA_W-1:0]    r_data    ;
  logic   [1:0]           r_resp    ;
  logic                   r_ready   ;
  logic                   r_valid   ;

  logic                   aw_ready  ;
  logic                   aw_valid  ;
  logic   [ADDR_W-1:0]    aw_addr   ;

  logic                   w_valid   ;
  logic   [DATA_W-1:0]    w_data    ;
  logic   [STRB_W-1:0]    w_strb    ;
  logic                   w_ready   ;

  logic   [1:0]           b_resp    ;
  logic                   b_ready   ;
  logic                   b_valid   ;

  modport Master
  (
    output ar_valid, ar_addr, input ar_ready,

    input  r_valid, r_data, r_resp, output r_ready,

    output aw_valid, aw_addr, input aw_ready,

    output w_valid, w_data, w_strb, input w_ready,

    input  b_valid, b_resp, output b_ready
  );

  modport Slave
  (
    input ar_valid, ar_addr, output ar_ready,

    output  r_valid, r_data, r_resp, input r_ready,

    input aw_valid, aw_addr, output aw_ready,

    input w_valid, w_data, w_strb, output w_ready,

    output  b_valid, b_resp, input b_ready
  );

endinterface


interface axi_if;
  parameter int ADDR_W = 32;
  parameter int DATA_W = 32;

  localparam int STRB_W = DATA_W / 8;

  logic                   ar_ready  ;
  logic                   ar_valid  ;
  logic   [ADDR_W-1:0]    ar_addr   ;
  axi_id_t                ar_id     ;
  axi_len_t               ar_len    ;
  axi_size_t              ar_size   ;
  axi_burst_t             ar_burst  ;

  logic   [DATA_W-1:0]    r_data    ;
  axi_resp_t              r_resp    ;
  logic                   r_ready   ;
  logic                   r_valid   ;
  logic                   r_last    ;
  axi_id_t                r_id      ;

  logic                   aw_ready  ;
  logic                   aw_valid  ;
  logic   [ADDR_W-1:0]    aw_addr   ;
  axi_id_t                aw_id     ;
  axi_len_t               aw_len    ;
  axi_size_t              aw_size   ;
  axi_burst_t             aw_burst  ;

  logic                   w_valid   ;
  logic   [DATA_W-1:0]    w_data    ;
  logic   [STRB_W-1:0]    w_strb    ;
  logic                   w_ready   ;
  logic                   w_last    ;

  logic   [1:0]           b_resp    ;
  logic                   b_ready   ;
  logic                   b_valid   ;
  axi_id_t                b_id      ;

  modport Master
  (
    output ar_valid, ar_addr, input ar_ready,
    output ar_id, ar_len, ar_size, ar_burst,

    input  r_valid, r_data, r_resp, output r_ready,
    input  r_last, r_id,

    output aw_valid, aw_addr, input aw_ready,
    output aw_id, aw_len, aw_size, aw_burst,

    output w_valid, w_data, w_strb, input w_ready,
    output w_last,

    input  b_valid, b_resp, output b_ready,
    input  b_id
  );

  modport Slave
  (
    input ar_valid, ar_addr, output ar_ready,
    input ar_id, ar_len, ar_size, ar_burst,

    output  r_valid, r_data, r_resp, input r_ready,
    output  r_last, r_id,

    input aw_valid, aw_addr, output aw_ready,
    input aw_id, aw_len, aw_size, aw_burst,

    input w_valid, w_data, w_strb, output w_ready,
    input w_last,

    output  b_valid, b_resp, input b_ready,
    output  b_id
  );

endinterface

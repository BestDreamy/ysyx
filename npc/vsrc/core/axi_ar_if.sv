interface axi_ar_if #(parameter int ADDR_W = 32);
    logic               ar_valid;
    logic               ar_ready;
    logic [ADDR_W-1:0]  ar_addr;
    // axi_id_t            ar_id;
    axi_len_t           ar_len;
    // axi_size_t          ar_size;
    axi_burst_t         ar_burst;
endinterface

// interface axi_r_if #(parameter int DATA_W = 32);
//     logic               r_valid;
//     logic               r_ready;
//     logic [DATA_W-1:0]  r_data;
//     axi_resp_t          r_resp;
// endinterface

// interface axi_aw_if #(parameter int ADDR_W = 32);
//     logic               aw_valid;
//     logic               aw_ready;
//     logic [ADDR_W-1:0]  aw_addr;
// endinterface

// interface axi_w_if #(parameter int DATA_W = 32);
//     localparam int STRB_W = DATA_W / 8;

//     logic                 w_valid;
//     logic                 w_ready;
//     logic [DATA_W-1:0]    w_data;
//     logic [STRB_W-1:0]    w_strb;
// endinterface

// interface axi_b_if;
//     logic                 b_valid;
//     logic                 b_ready;
//     axi_resp_t            b_resp;
// endinterface

// interface axi_if #(parameter int ADDR_W = 32, parameter int DATA_W = 32);
//     axi_ar_if #(ADDR_W) ar;
//     axi_r_if  #(DATA_W)  r;
//     axi_aw_if #(ADDR_W) aw;
//     axi_w_if  #(DATA_W)  w;
//     axi_b_if             b;

//     modport Master (
//         // AR Channel
//         output ar.ar_valid, ar.ar_addr, input ar.ar_ready,
//         // output ar.ar_id, ar.ar_len, ar.ar_size, ar.ar_burst,

//         // R Channel
//         input  r.r_valid, r.r_data, r.r_resp, output r.r_ready,
//         // input  r.r_last, r.r_id,

//         // AW Channel
//         output aw.aw_valid, aw.aw_addr, input aw.aw_ready,
//         // output aw.aw_id, aw.aw_len, aw.aw_size, aw.aw_burst,

//         // W Channel
//         output w.w_valid, w.w_data, w.w_strb, input w.w_ready,
//         // output w.w_last,

//         // B Channel
//         // input  b.b_id,
//         input  b.b_valid, b.b_resp, output b.b_ready
//     );

//     modport Slave (
//         // AR Channel
//         input  ar.ar_valid, ar.ar_addr, output ar.ar_ready,
//         // input  ar.ar_id, ar.ar_len, ar.ar_size, ar.ar_burst,

//         // R Channel
//         output r.r_valid, r.r_data, r.r_resp, input r.r_ready,
//         // output r.r_last, r.r_id,

//         // AW Channel
//         input  aw.aw_valid, aw.aw_addr, output aw.aw_ready,
//         // input  aw.aw_id, aw.aw_len, aw.aw_size, aw.aw_burst,

//         // W Channel
//         input  w.w_valid, w.w_data, w.w_strb, output w.w_ready,
//         // input  w.w_last,

//         // B Channel
//         // output b.b_id,
//         output b.b_valid, b.b_resp, input b.b_ready
//     );
// endinterface


// interface axi_if;
//   parameter int ADDR_W = 32;
//   parameter int DATA_W = 32;

//   localparam int STRB_W = DATA_W / 8;

//   logic                   ar_ready  ;
//   logic                   ar_valid  ;
//   logic   [ADDR_W-1:0]    ar_addr   ;
//   axi_id_t                ar_id     ;
//   axi_len_t               ar_len    ;
//   axi_size_t              ar_size   ;
//   axi_burst_t             ar_burst  ;

//   logic   [DATA_W-1:0]    r_data    ;
//   axi_resp_t              r_resp    ;
//   logic                   r_ready   ;
//   logic                   r_valid   ;
//   logic                   r_last    ;
//   axi_id_t                r_id      ;

//   logic                   aw_ready  ;
//   logic                   aw_valid  ;
//   logic   [ADDR_W-1:0]    aw_addr   ;
//   axi_id_t                aw_id     ;
//   axi_len_t               aw_len    ;
//   axi_size_t              aw_size   ;
//   axi_burst_t             aw_burst  ;

//   logic                   w_valid   ;
//   logic   [DATA_W-1:0]    w_data    ;
//   logic   [STRB_W-1:0]    w_strb    ;
//   logic                   w_ready   ;
//   logic                   w_last    ;

//   axi_resp_t              b_resp    ;
//   logic                   b_ready   ;
//   logic                   b_valid   ;
//   axi_id_t                b_id      ;

//   modport Slave
//   (
//     input  ar_valid, ar_addr, output ar_ready,
//     input  ar_id, ar_len, ar_size, ar_burst,

//     output r_valid, r_data, r_resp, input r_ready,
//     output r_last, r_id,

//     input  aw_valid, aw_addr, output aw_ready,
//     input  aw_id, aw_len, aw_size, aw_burst,

//     input  w_valid, w_data, w_strb, output w_ready,
//     input  w_last,

//     output b_valid, b_resp, input b_ready,
//     output b_id
//   );

//   modport Master
//   (
//     output ar_valid, ar_addr, input ar_ready,
//     output ar_id, ar_len, ar_size, ar_burst,

//     input  r_valid, r_data, r_resp, output r_ready,
//     input  r_last, r_id,

//     output aw_valid, aw_addr, input aw_ready,
//     output aw_id, aw_len, aw_size, aw_burst,

//     output w_valid, w_data, w_strb, input w_ready,
//     output w_last,

//     input  b_valid, b_resp, output b_ready,
//     input  b_id
//   );

// endinterface

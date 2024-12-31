interface axi_w_if #(parameter int DATA_W = 32);
    localparam int STRB_W = DATA_W / 8;

    logic                 w_valid;
    logic                 w_ready;
    logic [DATA_W-1:0]    w_data;
    logic [STRB_W-1:0]    w_strb;
    logic                 w_last;
    
  modport Slave
  (
    input  w_valid, w_data, w_strb, output w_ready,
    input  w_last
  );

  modport Master
  (
    output w_valid, w_data, w_strb, input w_ready,
    output w_last
  );
endinterface


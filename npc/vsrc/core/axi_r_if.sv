interface axi_r_if #(parameter int DATA_W = 32);
    logic               r_valid;
    logic               r_ready;
    logic [DATA_W-1:0]  r_data;
    axi_resp_t          r_resp;
endinterface
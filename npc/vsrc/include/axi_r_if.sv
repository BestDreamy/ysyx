interface axi_r_if #(parameter int DATA_W = 32);
    logic               r_valid;
    logic               r_ready;
    logic [DATA_W-1:0]  r_data;
    axi_resp_t          r_resp;
    logic               r_last;
    axi_id_t            r_id;

    modport Slave
    (
        output r_valid, r_data, r_resp, input r_ready,
        output r_last, r_id
    );

    modport Master
    (
        input  r_valid, r_data, r_resp, output r_ready,
        input  r_last, r_id
    );
endinterface


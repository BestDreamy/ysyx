interface axi_b_if;
    logic                 b_valid;
    logic                 b_ready;
    axi_resp_t            b_resp;
    axi_id_t              b_id;

    modport Slave
    (
        output b_valid, b_resp, input b_ready,
        output b_id
    );

    modport Master
    (
        input  b_valid, b_resp, output b_ready,
        input  b_id
    );
endinterface


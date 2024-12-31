interface axi_aw_if #(parameter int ADDR_W = 32);
    logic               aw_valid;
    logic               aw_ready;
    logic [ADDR_W-1:0]  aw_addr;
    axi_id_t            aw_id;
    axi_len_t           aw_len;
    axi_size_t          aw_size;
    axi_burst_t         aw_burst;

    modport Slave
    (
        input  aw_valid, aw_addr, output aw_ready,
        input  aw_id, aw_len, aw_size, aw_burst
    );

    modport Master
    (
        output aw_valid, aw_addr, input aw_ready,
        output aw_id, aw_len, aw_size, aw_burst
    );
endinterface


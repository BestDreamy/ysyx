`include "defines"
`include "typedefs"
`include "assign"

module top (
    output [`ysyx_23060251_pc_bus]   pc,
    // output [`ysyx_23060251_inst_bus] inst,

    input                                clk,
    input                                rst
);

	core inst_core
    (
        .pc                (pc),
        .mstatus           (),
        .mtvec             (),
        .mepc              (),
        .mcause            (),
        .inst              (),
        .io_master_awready (io_master_awready),
        .io_slave_awready  (io_slave_awready),
        .io_master_awvalid (io_master_awvalid),
        .io_slave_awvalid  (io_slave_awvalid),
        .io_master_awaddr  (io_master_awaddr),
        .io_slave_awaddr   (io_slave_awaddr),
        .io_master_wready  (io_master_wready),
        .io_slave_wready   (io_slave_wready),
        .io_master_wvalid  (io_master_wvalid),
        .io_slave_wvalid   (io_slave_wvalid),
        .io_master_wdata   (io_master_wdata),
        .io_slave_wdata    (io_slave_wdata),
        .io_master_wstrb   (io_master_wstrb),
        .io_slave_wstrb    (io_slave_wstrb),
        .io_master_bready  (io_master_bready),
        .io_slave_bready   (io_slave_bready),
        .io_master_bvalid  (io_master_bvalid),
        .io_slave_bvalid   (io_slave_bvalid),
        .io_master_bresp   (io_master_bresp),
        .io_slave_bresp    (io_slave_bresp),
        .io_master_arready (io_master_arready),
        .io_slave_arready  (io_slave_arready),
        .io_master_arvalid (io_master_arvalid),
        .io_slave_arvalid  (io_slave_arvalid),
        .io_master_araddr  (io_master_araddr),
        .io_slave_araddr   (io_slave_araddr),
        .io_master_rready  (io_master_rready),
        .io_slave_rready   (io_slave_rready),
        .io_master_rvalid  (io_master_rvalid),
        .io_slave_rvalid   (io_slave_rvalid),
        .io_master_rresp   (io_master_rresp),
        .io_slave_rresp    (io_slave_rresp),
        .io_master_rdata   (io_master_rdata),
        .io_slave_rdata    (io_slave_rdata),
        .clk               (clk),
        .rst               (rst)
    );

endmodule
`include "defines"
`include "typedefs"
`include "assigns"

module top (
    output [`ysyx_23060251_pc_bus]       pc,
    output [`ysyx_23060251_inst_bus]     inst,    // just for itrace
    output wire[`ysyx_23060251_reg_bus]  mstatus, // just for diff
    output wire[`ysyx_23060251_reg_bus]  mtvec,   // just for diff
    output wire[`ysyx_23060251_reg_bus]  mepc,    // just for diff
    output wire[`ysyx_23060251_reg_bus]  mcause,  // just for diff

    input                                clk,
    input                                rst
);

    wire          io_master_awready; wire           io_slave_awready;
    wire          io_master_awvalid; wire           io_slave_awvalid;
    wire [31:0]   io_master_awaddr ; wire [31:0]    io_slave_awaddr ;

    wire          io_master_wready ; wire           io_slave_wready ;
    wire          io_master_wvalid ; wire           io_slave_wvalid ;
    wire [31:0]   io_master_wdata  ; wire [31:0]    io_slave_wdata  ;
    wire [3:0]    io_master_wstrb  ; wire [3:0]     io_slave_wstrb  ;

    wire          io_master_bready ; wire           io_slave_bready ;
    wire          io_master_bvalid ; wire           io_slave_bvalid ;
    wire [1:0]    io_master_bresp  ; wire [1:0]     io_slave_bresp  ;

    wire          io_master_arready; wire           io_slave_arready;
    wire          io_master_arvalid; wire           io_slave_arvalid;
    wire [31:0]   io_master_araddr ; wire [31:0]    io_slave_araddr ;

    wire          io_master_rready ; wire           io_slave_rready ;
    wire          io_master_rvalid ; wire           io_slave_rvalid ;
    wire [1:0]    io_master_rresp  ; wire [1:0]     io_slave_rresp  ;
    wire [31:0]   io_master_rdata  ; wire [31:0]    io_slave_rdata  ;

    core ysyx_core
    (
        .pc                (pc),
        .mstatus           (),
        .mtvec             (),
        .mepc              (),
        .mcause            (),
        .inst              (inst),
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

    axi_slave ysyx_ram
    (
        .slv_ar_valid_i (io_master_arvalid),
        .slv_ar_addr_i  (io_master_araddr),
        .slv_ar_ready_o (io_master_arready),
        .slv_r_valid_o  (io_master_rvalid),
        .slv_r_data_o   (io_master_rdata),
        .slv_r_resp_o   (io_master_rresp),
        .slv_r_ready_i  (io_master_rready),
        .slv_aw_valid_i (io_master_awvalid),
        .slv_aw_addr_i  (io_master_awaddr),
        .slv_aw_ready_o (io_master_awready),
        .slv_w_valid_i  (io_master_wvalid),
        .slv_w_data_i   (io_master_wdata),
        .slv_w_strb_i   (io_master_wstrb),
        .slv_w_ready_o  (io_master_wready),
        .slv_b_valid_o  (io_master_bvalid),
        .slv_b_resp_o   (io_master_bresp),
        .slv_b_ready_i  (io_master_bready),
        .clk_i          (clk),
        .rst_i          (rst)
    );

endmodule

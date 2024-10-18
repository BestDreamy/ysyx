module axi_slave (
    // AXI LITE
    input                                  slv_ar_valid_i,
    input  [`ysyx_23060251_axi_addr_bus]   slv_ar_addr_i,
    output                                 slv_ar_ready_o,

    output                                 slv_r_valid_o,
    output [`ysyx_23060251_axi_data_bus]   slv_r_data_o,
    output axi_resp_t                      slv_r_resp_o,
    input                                  slv_r_ready_i,

    input                                  slv_aw_valid_i,
    input  [`ysyx_23060251_axi_addr_bus]   slv_aw_addr_i,
    output                                 slv_aw_ready_o,

    input                                  slv_w_valid_i,
    input  [`ysyx_23060251_axi_data_bus]   slv_w_data_i,
    input  [`ysyx_23060251_axi_strb_bus]   slv_w_strb_i,
    output                                 slv_w_ready_o,

    output                                 slv_b_valid_o,
    output axi_resp_t                      slv_b_resp_o,
    input                                  slv_b_ready_i,

    input                                  clk_i,
    input                                  rst_i
);
    import "DPI-C" function int vaddr_read(int addr);
    import "DPI-C" function void vaddr_write(int addr, byte mask, int data);

    localparam AXI_SLV_R_STATE_NR = 3;
    localparam AXI_SLV_W_STATE_NR = 4;
    localparam AXI_SLV_STATE_NR   = AXI_SLV_R_STATE_NR + AXI_SLV_W_STATE_NR - 1;
    localparam [AXI_SLV_STATE_NR-1: 0] IDLE      = 6'b1;
    localparam [AXI_SLV_STATE_NR-1: 0] READ_MEM  = 6'b10 ,  READ_RSP  = 6'b100;
    localparam [AXI_SLV_STATE_NR-1: 0] WRITE_REQ = 6'b1000, WRITE_MEM = 6'b1_0000, WRITE_RSP = 6'b10_0000;

    reg [AXI_SLV_STATE_NR-1: 0] r_state, r_next_state;
    reg [AXI_SLV_STATE_NR-1: 0] w_state, w_next_state;

    wire ar_hs, r_hs, aw_hs, w_hs, b_hs;

    reg [`ysyx_23060251_axi_addr_bus] rd_addr_buf;
    reg [`ysyx_23060251_axi_data_bus] rd_data_buf;

    reg [`ysyx_23060251_axi_addr_bus] wt_addr_buf;
    reg [`ysyx_23060251_axi_data_bus] wt_data_buf;
    reg [`ysyx_23060251_axi_strb_bus] wt_strb_buf;

    reg [3: 0] rd_count, wt_count;

    // --------------------------- state machine ----------------------------
    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) begin
            r_state <= IDLE;
        end else begin
            r_state <= r_next_state;
        end
    end

    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) begin
            w_state <= IDLE;
        end else begin
            w_state <= w_next_state;
        end
    end

    always_comb begin
        if (r_state == IDLE) begin
            if (ar_hs)
                r_next_state = READ_MEM;
            else
                r_next_state = r_state;
        end else if (r_state == READ_MEM) begin
            if (rd_count == 0)
                r_next_state = READ_RSP;
            else
                r_next_state = r_state;
        end else begin // if (r_state == READ_RSP) begin
            if (r_hs)
                r_next_state = IDLE;
            else
                r_next_state = r_state;
        end
    end

    always_comb begin
        if (w_state == IDLE) begin
            if (aw_hs)
                w_next_state = WRITE_REQ;
            else
                w_next_state = w_state;
        end else if (w_state == WRITE_REQ) begin
            if (w_hs)
                w_next_state = WRITE_MEM;
            else
                w_next_state = w_state;
        end else if (w_state == WRITE_MEM) begin
            if (wt_count == 0)
                w_next_state = WRITE_RSP;
            else
                w_next_state = w_state;
        end else begin // w_state == WRITE_RSP
            if (b_hs)
                w_next_state = IDLE;
            else
                w_next_state = w_state;
        end
    end

    always @(posedge clk_i) begin
        if (r_state == IDLE & r_next_state == READ_MEM)
            // count <= $random;
            rd_count <= 4'd7;
        else if (r_state == READ_MEM)
            rd_count <= rd_count - 1;
    end

    always @(posedge clk_i) begin
        if (r_state == IDLE & r_next_state == READ_MEM)
            rd_addr_buf <= slv_ar_addr_i;
    end

    always @(posedge clk_i) begin
        if (r_state == READ_MEM & r_next_state == READ_RSP)
            rd_data_buf <= vaddr_read(rd_addr_buf);
    end

    assign slv_ar_ready_o = (r_state == IDLE);
    assign slv_r_valid_o  = (r_state == READ_RSP);
    assign slv_r_data_o   = rd_data_buf;
    assign slv_r_resp_o   = 2'b00;

    always @(posedge clk_i) begin
        if (w_state == WRITE_REQ & w_next_state == WRITE_MEM)
            // count <= $random;
            wt_count <= 4'd7;
        else if (w_state == WRITE_MEM)
            wt_count <= wt_count - 1;
    end

    always @(posedge clk_i) begin
        if (w_state == IDLE & w_next_state == WRITE_REQ)
            wt_addr_buf <= slv_aw_addr_i;
    end

    always @(posedge clk_i) begin
        if (w_state == WRITE_REQ & w_next_state == WRITE_MEM)
            wt_data_buf <= slv_w_data_i;
    end

    always @(posedge clk_i) begin
        if (w_state == WRITE_REQ & w_next_state == WRITE_MEM)
            wt_strb_buf <= slv_w_strb_i;
    end

    always @(posedge clk_i) begin
        if (w_state == WRITE_MEM & w_next_state == WRITE_RSP)
            vaddr_write(wt_addr_buf, wt_strb_buf, wt_data_buf);
    end

    assign slv_aw_ready_o = (w_state == IDLE);
    assign slv_w_ready_o  = (w_state == WRITE_REQ);
    assign slv_b_valid_o  = (w_state == WRITE_RSP);
    assign slv_b_resp_o   = 2'b00;
    // ---------------------- state machine end -------------------------------

    assign ar_hs = slv_ar_valid_i & slv_ar_ready_o;
    assign r_hs  = slv_r_valid_o  & slv_r_ready_i ;
    assign aw_hs = slv_aw_valid_i & slv_aw_ready_o;
    assign w_hs  = slv_w_valid_i  & slv_w_ready_o ;
    assign b_hs  = slv_b_valid_o  & slv_b_ready_i ;
endmodule

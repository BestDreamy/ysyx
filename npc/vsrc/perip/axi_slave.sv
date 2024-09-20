module axi_slave (
	// AXI LITE
    input                                  slv_ar_valid_i,
    input  [`ysyx_23060251_axi_addr_bus]   slv_ar_addr_i,
    output                                 slv_ar_ready_o,

    output                                 slv_r_valid_o,
    output [`ysyx_23060251_axi_data_bus]   slv_r_data_o,
    output axi_mst_resp_t                  slv_r_resp_o,
    input                                  slv_r_ready_i,

    input                                  slv_aw_valid_i,
    input  [`ysyx_23060251_axi_addr_bus]   slv_aw_addr_i,
    output                                 slv_aw_ready_o,

    input                                  slv_w_valid_i,
    input  [`ysyx_23060251_axi_data_bus]   slv_w_data_i,
    input  [`ysyx_23060251_axi_strb_bus]   slv_w_strb_i,
    output                                 slv_w_ready_o,

    output                                 slv_b_valid_o,
    output axi_mst_resp_t                  slv_b_resp_o,
    input                                  slv_b_ready_i,

    input                                  clk_i,
    input                                  rst_i
);
	import "DPI-C" function int vaddr_read(int addr);
    import "DPI-C" function void vaddr_write(int addr, byte mask, int data);

	localparam AXI_SLV_R_STATE_NR = 3;
	localparam AXI_SLV_W_STATE_NR = 4;
	localparam AXI_SLV_STATE_NR   = AXI_SLV_R_STATE_NR + AXI_SLV_W_STATE_NR - 1;
    localparam [AXI_SLV_STATE_NR-1: 0] IDLE      = AXI_SLV_STATE_NR'b1;
    localparam [AXI_SLV_STATE_NR-1: 0] READ_MEM  = AXI_SLV_STATE_NR'b10 ,  READ_RSP  = AXI_SLV_STATE_NR'b100;
    localparam [AXI_SLV_STATE_NR-1: 0] WRITE_REQ = AXI_SLV_STATE_NR'h1000, WRITE_MEM = AXI_SLV_STATE_NR'b1_0000, WRITE_RSP = AXI_SLV_STATE_NR'b10_0000;

    reg [AXI_SLV_STATE_NR-1: 0] state, next_state;
    // reg [AXI_SLV_STATE_NR-1: 0] w_state, w_next_state;

    wire ar_hs, r_hs, aw_hs, w_hs, b_hs;

    reg [`ysyx_23060251_axi_addr_bus] addr_buf;
    reg [`ysyx_23060251_axi_data_bus] data_buf;
    reg [`ysyx_23060251_axi_strb_bus] strb_buf;

    reg [3: 0] count;

    // --------------------------- state machine ----------------------------
    always @(posedge clk_i) begin
        if (rst_i == `ysyx_23060251_rst_enable) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        if (state == IDLE) begin
            if (ar_hs)
                next_state = READ_MEM;
            else
                next_state = state;
        end else if (state == READ_MEM) begin
            if (count == 0) 
                next_state = READ_RSP;
            else 
                next_state = state;
        end else begin // state == READ_RSP
        	if (r_hs) 
            	next_state = IDLE;
            else 
            	next_state = state;
        end
    end

    always @(posedge clk_i) begin
    	if (state == IDLE & next_state == READ_MEM)
    		count <= $random;
    	else if (state == READ_MEM)
    		count <= count - 1;
    end

    always @(posedge clk_i) begin
    	if (state == IDLE & next_state == READ_MEM)
    		addr_buf <= slv_ar_addr_i;
    end

	always @(posedge clk_i) begin
		if (state == READ_MEM & next_state == READ_RSP)
			data_buf <= vaddr_read(addr_buf);
	end    

	assign slv_ar_ready_o = (state == IDLE);
	assign slv_r_valid_o  = (state == READ_RSP);
	assign slv_r_data_o   = data_buf;
	assign slv_r_resp_o   = 2'b00;

    always_comb begin
        if (state == IDLE) begin
            if (aw_hs)
                next_state = WRITE_REQ;
            else
                next_state = state;
        end else if (state == WRITE_REQ) begin
            if (w_hs) 
                next_state = WRITE_MEM;
            else 
                next_state = state;
        end else if (state == WRITE_MEM) begin
            if (count == 0)
                next_state = WRITE_RSP;
            else 
                next_state = state;
        end else begin // state == WRITE_RSP
            if (b_hs)
                next_state = IDLE;
            else 
                next_state = state;
        end
    end

    always @(posedge clk_i) begin
    	if (state == IDLE & next_state == WRITE_REQ)
    		addr_buf <= slv_aw_addr_i; 
    end

    always @(posedge clk_i) begin
    	if (state == WRITE_REQ & next_state == WRITE_MEM)
    		data_buf <= slv_w_data_i;
    end

    always @(posedge clk_i) begin
    	if (state == WRITE_REQ & next_state == WRITE_MEM)
    		strb_buf <= slv_w_strb_i;
    end

    always @(posedge clk_i) begin
    	if (state == WRITE_REQ & next_state == WRITE_MEM)
    		count <= $random;
    	else if (state == WRITE_MEM)
    		count = count - 1;
    end

    assign slv_aw_ready_o = (state == IDLE);
    assign slv_w_ready_o  = (state == WRITE_REQ);
    assign slv_b_valid_o  = (state == WRITE_RSP);
    assign slv_b_resp_o   = 2'b00;
    // ---------------------- state machine end -------------------------------
endmodule
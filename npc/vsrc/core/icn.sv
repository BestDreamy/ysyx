module icn (
    // axi_if.Slave  axi_slv,
    // axi_if.Master axi_mst,
    
    input clk_i,
    input rst_i
);
    // localparam [2: 0] R_WAIT_ADDR = 3'b001, R_WAIT_ACC = 3'b010, R_DONE = 3'b100;
    // // localparam [2: 0] W_WAIT_ADDR = 3'b001, W_WAIT_DATA = 3'b010, W_WAIT_DONE = 3'b100;

    // reg[1: 0] r_state, r_next;
    // reg[2: 0] w_state, w_next;

    // wire ar_hs, r_hs, aw_hs, w_hs, b_hs;

    // reg[`ysyx_23060251_axi_addr_bus] r_addr, w_addr;
    // reg[`ysyx_23060251_axi_data_bus] r_data, w_data;

    // // reg[3: 0] r_count, w_count;
    // // wire r_count_en, w_count_en;

    // // assign r_count_en = (r_state == R_WAIT_ACC) & (r_count > 0);

    // // always @(posedge clk_i) begin
    // //     if (r_count_en)
    // //         r_count = r_count - 1;
    // // end

    // // ---------------------- read state machine ----------------------------
    // always @(posedge clk_i) begin
    //     if (rst_i == `ysyx_23060251_rst_enable) begin
    //         r_state <= R_WAIT_ADDR;
    //     end else begin
    //         r_state <= r_next;
    //     end
    // end

    // always_comb begin
    //     if (r_state == R_WAIT_ADDR) begin
    //         if (ar_hs)
    //             r_next = R_WAIT_ACC;
    //         else
    //             r_next = R_WAIT_ADDR;
    //     end else if (r_state == R_WAIT_ACC) begin
    //         if (count == 0)
    //             r_next = R_DONE;
    //         else
    //             r_next = R_WAIT_ACC;
    //     end else begin // r_state == R_DONE
    //         if (r_hs)
    //             r_next = R_WAIT_ADDR;
    //         else
    //             r_next = R_DONE;
    //     end
    // end
    // // ---------------------- state machine end -------------------------------

    // // assign axi_mst.ar_ready = (r_state == R_WAIT_ADDR);
    // // assign axi_mst.r_valid  = (r_state == R_DONE);
    // // assign axi_mst.r_data   = axi_slv.r_data;
    // // assign axi_mst.r_resp   = axi_slv.r_resp;

    // // assign axi_slv.ar_valid = (r_state == R_WAIT_ACC);
    // // assign axi_slv.ar_addr  = axi_mst.ar_addr;
    // // assign axi_slv.r_ready  = (r_count == 0);

    // axi_xp #(
    //     .DATA_WIDTH(`ysyx_23060251_axi_addr)
    // ) axi_xp_addr (
    //     .clk        (clk_i),
    //     .rstn       (rst_i),
    //     .pin_valid  (axi_slv.ar_valid),
    //     .pin_data   (axi_slv.ar_addr),
    //     .pin_ready  (axi_slv.ar_ready),
    //     .pout_valid (axi_mst.ar_valid),
    //     .pout_data  (axi_mst.ar_addr),
    //     .pout_ready (axi_mst.ar_ready)
    // );

endmodule

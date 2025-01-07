module axi_Xbar (
    axi_ar_if.Slave                   axi_slv_ar,
    axi_r_if.Slave                    axi_slv_r,
    axi_aw_if.Slave                   axi_slv_aw,
    axi_w_if.Slave                    axi_slv_w,
    axi_b_if.Slave                    axi_slv_b,

    axi_ar_if.Master                  axi_mst_ar,
    axi_r_if.Master                   axi_mst_r,
    axi_aw_if.Master                  axi_mst_aw,
    axi_w_if.Master                   axi_mst_w,
    axi_b_if.Master                   axi_mst_b
);

endmodule
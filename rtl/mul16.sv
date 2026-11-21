`timescale 1ns/1ps
// =============================================================
// Bo nhan W x W bit, giao tiep valid/ready. Dac ta: doc/dac-ta.md
//
// Lab 2 - Phan 2: phan khai bao cong duoi day co 6 cho SAI so voi
//                 bang cong trong dac ta. Sua bang vi.
// Lab 5         : khai bao trang thai va thanh ghi (TODO ben duoi),
//                 viet bo dieu khien va datapath, xoa doan TAM THOI.
// =============================================================
module mul16 #(
    parameter int W = 16
) (
    input  wire            clk,
    input  wire            reset,
    // phia yeu cau
    input  wire            req_valid,
    output reg             req_ready,
    input  wire  [W:0]     a,
    input  wire  [W-1:0]   b
    // phia ket qua
    output reg             resp_valid,
    input  wire            resp_ready,
    output reg   [W-1:0]   prod
);
    // TODO (Lab 5): kieu enum cho 3 trang thai, bien state va state_next

    // TODO (Lab 5): khai bao 4 thanh ghi cua datapath theo bang
    //                        "Thanh ghi" trong dac ta (ten, do rong)

    // ===== TAM THOI: gan hang so de bien dich duoc. Xoa o Lab 5. =====
    assign req_ready  = 1'b0;
    assign resp_valid = 1'b0;
    assign prod       = '0;
endmodule

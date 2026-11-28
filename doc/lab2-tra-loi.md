# Báo cáo Lab 2: Công cụ làm việc
Họ và tên: Nguyen Nhan Duc  
MSSV: 77482403177  
---
## Phần 1: Lệnh Linux
### Q1. Commit treo, sai, đúng và tín hiệu nghi ngờ
- Lệnh: `head -n 1 logs/*.log` và `tail -n 1 logs/*.log`
- Kết quả:
  - `run_01.log` (commit `a1f3c09`): Bị TREO (thông báo hết thời gian sau 0 phép nhân).
  - `run_02.log`, `run_03.log` (commit `5be2d14`): Cho kết quả SAI (lần lượt sai 103/206 và 88/206).
  - `run_04.log`, `run_05.log` (commit `c7e90aa`): Cho kết quả ĐÚNG (PASS 206/206).
- Theo testbench, phiên bản bị treo có thể hỏng ở tín hiệu `req_ready` hoặc `resp_valid` không bao giờ tích cực lên 1.
### Q2. Tổng số phép nhân sai và số dòng LOI
- Lệnh tính tổng sai: `grep -h 'phep nhan sai' logs/*.log | awk '{s += $2} END {print s}'` -> Kết quả: 191
- Lệnh đếm dòng LOI: `grep -c LOI logs/*.log` -> Kết quả: 20 dòng
- Giải thích: Trong testbench `tb/tb_mul16_smoke.sv` có điều kiện `if (errors <= 10)` khống chế chỉ in tối đa 10 lỗi đầu tiên mỗi lần chạy để tránh tràn màn hình log. Vì vậy 2 log sai in ra tổng cộng 20 dòng LOI.
### Q3. Điểm chung của b sai, bit bị bỏ qua và vị trí lỗi FSM
- Lệnh: `grep -oh 'b=0x[0-9a-f]' logs/*.log | sort | uniq -c`
- Kết quả: Chữ số hex đầu của b luôn nằm từ `8` đến `f`.
- Phân tích: Các số hex từ 8 đến f đều có bit cao nhất (bit 15: `b[15]`) bằng 1. Như vậy bit 15 của b đã bị bỏ qua không được nhân.
- Dự đoán lỗi FSM: Điều kiện chuyển từ `CALC` sang `DONE` bị sai, có thể FSM chuyển trạng thái quá sớm khi `cnt = W - 2` thay vì `cnt = W - 1`, làm thiếu mất 1 chu kỳ tính toán cho bit 15.
### Q4. Kiểm tra giả thuyết với python3
- Lệnh: `python3 -c "a=0x0003; b=0x8001; print(hex(a * (b % 0x8000)))"`
- Kết quả in ra: `0x3` (tức `0x00000003`).
- So sánh: Khớp hoàn toàn với giá trị `p=0x00000003` ghi trong log của trường hợp này. Điều này khẳng định bit 15 đã bị mất.
### Q5. Khác biệt giữa > và >>
- Lệnh thực nghiệm:
  - `grep -h LOI logs/*.log > doc/loi-mau.txt` chạy 2 lần -> `wc -l doc/loi-mau.txt` ra 20 dòng.
  - `grep -h LOI logs/*.log >> doc/loi-mau.txt` chạy thêm 1 lần -> `wc -l doc/loi-mau.txt` ra 40 dòng.
- Giải thích: `>` là ghi đè (overwrite), xóa sạch nội dung cũ; `>>` là ghi nối tiếp (append) vào cuối file.
---
## Phần 2: Soạn thảo bằng vi/vim
### Q6. Liệt kê 6 chỗ sai đã sửa trong rtl/mul16.sv
1. Dòng 14: Tên cổng `reset` sửa thành `rst`.
2. Toàn bộ cổng: Kiểu `wire` và `reg` sửa thành chuẩn SystemVerilog `logic`.
3. Dòng 18: Độ rộng cổng `a` từ `[W:0]` (17 bit) sửa thành `[W-1:0]` (16 bit).
4. Dòng 19: Cuối dòng cổng `b` thiếu dấu phẩy `,`, đã thêm dấu phẩy `,`.
5. Dòng 23 & dòng 33: Tên cổng kết quả `prod` sửa thành `p`.
6. Dòng 23: Độ rộng cổng `p` từ `[W-1:0]` (16 bit) sửa thành `[2*W-1:0]` (32 bit).
### Q7. Vì sao đổi tên phải dùng \<prod\> thay vì prod?
- `\<` và `\>` là ký hiệu khớp chính xác một từ độc lập (word boundary).
- Nếu chỉ dùng `prod`, lệnh thay thế sẽ đổi nhầm các từ chứa chuỗi đó (ví dụ: biến `product` sẽ bị đổi nhầm thành `pukt`). Dùng `\<prod\>` giúp tránh đổi nhầm tên biến khác.
### Q8. Độ rộng cổng p và giá trị 0xFFFF × 0xFFFF
- Với W = 16, cổng `p` rộng 2W = 32 bit.
- Phép nhân chuẩn: 0xFFFF × 0xFFFF = 65535 × 65535 = 4294836225 = 0xFFFE0001 (32 bit).
- Nếu để `p` rộng W = 16 bit như bản gốc, kết quả bị tràn và cắt mất 16 bit cao, chỉ còn lại 16 bit thấp: 0xFFFE0001 & 0xFFFF = 0x0001.

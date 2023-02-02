USE database_furama;
--  2 Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự.
SELECT 
    *
FROM
    nhan_vien
WHERE
    SUBSTRING_INDEX(nhan_vien.ho_va_ten, ' ', - 1) LIKE 'H%'
        OR SUBSTRING_INDEX(nhan_vien.ho_va_ten, ' ', - 1) LIKE 'T%'
        OR SUBSTRING_INDEX(nhan_vien.ho_va_ten, ' ', - 1) LIKE 'K%'
        AND CHAR_LENGTH(ho_va_ten) <= 15;
--  3 Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
SELECT 
    *
FROM
    khach_hang
WHERE
    (khach_hang.dia_chi LIKE '% Quảng Trị'
        OR khach_hang.dia_chi LIKE '% Đà Nẵng')
        AND YEAR(CURRENT_DATE()) - YEAR(ngay_sinh) BETWEEN 18 AND 50;
 -- 4 Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần. 
SELECT 
    khach_hang.ma_khach_hang,
    khach_hang.ho_ten,
    COUNT(khach_hang.ma_khach_hang) AS 'so_lan_dat_phong'
FROM
    khach_hang
        JOIN
    hop_dong ON khach_hang.ma_khach_hang = hop_dong.ma_khach_hang
        JOIN
    loai_khach ON khach_hang.ma_loai_khach = loai_khach.ma_loai_khach
WHERE
    ten_loai_khach = 'Diamond'
GROUP BY khach_hang.ma_khach_hang
ORDER BY COUNT(khach_hang.ma_khach_hang);
-- 5 Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien 
-- (Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) 
-- cho tất cả các khách hàng đã từng đặt phòng.
-- (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra).
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT 
    khach_hang.ma_khach_hang,
    khach_hang.ho_ten,
    loai_khach.ten_loai_khach,
    hop_dong.ma_hop_dong,
    dich_vu.ten_dich_vu,
    hop_dong.ngay_lam_hop_dong,
    hop_dong.ngay_ket_thuc,
    SUM(IFNULL(dich_vu.chi_phi_thue, 0) + IFNULL(hop_dong_chi_tiet.so_luong, 0) * IFNULL(dich_vu_di_kem.gia, 0)) 'total'
FROM
    khach_hang
        LEFT JOIN
    loai_khach ON khach_hang.ma_loai_khach = loai_khach.ma_loai_khach
        LEFT JOIN
    hop_dong ON khach_hang.ma_khach_hang = hop_dong.ma_khach_hang
        LEFT JOIN
    dich_vu ON hop_dong.ma_dich_vu = dich_vu.ma_dich_vu
        LEFT JOIN
    loai_dich_vu ON loai_dich_vu.ma_loai_dich_vu = dich_vu.ma_loai_dich_vu
        LEFT JOIN
    hop_dong_chi_tiet ON hop_dong.ma_hop_dong = hop_dong_chi_tiet.ma_hop_dong
        LEFT JOIN
    dich_vu_di_kem ON dich_vu_di_kem.ma_dich_vu_di_kem = hop_dong_chi_tiet.ma_dich_vu_di_kem
GROUP BY ma_hop_dong , khach_hang.ma_khach_hang
ORDER BY ma_khach_hang ASC , ma_hop_dong DESC;
-- 	6 Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue, ten_loai_dich_vu của tất cả các loại dịch vụ chưa từng được khách hàng thực hiện đặt từ quý 1 của năm 2021 
-- (Quý 1 là tháng 1, 2, 3).
SELECT 
    dich_vu.ma_dich_vu,
    dich_vu.ten_dich_vu,
    dich_vu.dien_tich,
    dich_vu.chi_phi_thue,
    loai_dich_vu.ten_loai_dich_vu,
    hop_dong.ngay_lam_hop_dong
FROM
    dich_vu
        JOIN
    loai_dich_vu ON loai_dich_vu.ma_loai_dich_vu = dich_vu.ma_loai_dich_vu
        JOIN
    hop_dong ON hop_dong.ma_dich_vu = dich_vu.ma_dich_vu
WHERE
    dich_vu.ma_dich_vu NOT IN (SELECT 
            hop_dong.ma_dich_vu
        FROM
            hop_dong
        WHERE
            ((MONTH(hop_dong.ngay_lam_hop_dong) BETWEEN 1 AND 3)
                AND YEAR(hop_dong.ngay_lam_hop_dong) LIKE 2021))
GROUP BY dich_vu.ten_dich_vu;
-- 7 Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu
-- của tất cả các loại dịch vụ đã từng được khách hàng đặt phòng trong năm 2020
-- nhưng chưa từng được khách hàng đặt phòng trong năm 2021.

SELECT 
    dv.ma_dich_vu,
    dv.ten_dich_vu,
    dv.dien_tich,
    dv.so_nguoi_toi_da,
    dv.chi_phi_thue,
    ldv.ten_loai_dich_vu
FROM
    dich_vu dv
        JOIN
    loai_dich_vu ldv ON dv.ma_loai_dich_vu = ldv.ma_loai_dich_vu
WHERE
    dv.ma_dich_vu IN (SELECT 
            hop_dong.ma_dich_vu
        FROM
            hop_dong
        WHERE
            YEAR(hop_dong.ngay_lam_hop_dong) = 2020)
        AND dv.ma_dich_vu NOT IN (SELECT 
            hop_dong.ma_dich_vu
        FROM
            hop_dong
        WHERE
            YEAR(hop_dong.ngay_lam_hop_dong) = 2021)
GROUP BY dv.ma_dich_vu , dv.ten_dich_vu , dv.dien_tich , dv.so_nguoi_toi_da , dv.chi_phi_thue , ldv.ten_loai_dich_vu
;

-- 8 Hiển thị thông tin ho_ten khách hàng có trong hệ thống, với yêu cầu ho_ten không trùng nhau.
-- Học viên sử dụng theo 3 cách khác nhau để thực hiện yêu cầu trên.
-- c1
SELECT 
    khach_hang.ho_ten
FROM
    khach_hang
GROUP BY khach_hang.ho_ten;
-- c2
SELECT DISTINCT
    khach_hang.ho_ten
FROM
    khach_hang;
-- c3
SELECT 
    khach_hang.ho_ten
FROM
    khach_hang
GROUP BY khach_hang.ho_ten
HAVING COUNT(khach_hang.ho_ten) < 3;

-- 9 Thực hiện thống kê doanh thu theo tháng, nghĩa là tương ứng với mỗi tháng trong năm 2021 thì sẽ có bao nhiêu khách hàng thực hiện đặt phòng.
SELECT 
    MONTH(hd.ngay_lam_hop_dong) AS thang,
    COUNT(hd.ma_khach_hang) AS so_luong_khach_hang
FROM
    hop_dong hd
WHERE
    YEAR(hd.ngay_lam_hop_dong) = 2021
GROUP BY thang
ORDER BY thang
;

-- 10	Hiển thị thông tin tương ứng với từng hợp đồng thì đã sử dụng bao nhiêu dịch vụ đi kèm.
SELECT 
    hd.ma_hop_dong,
    hd.ngay_lam_hop_dong,
    hd.ngay_ket_thuc,
    hd.tien_dat_coc,
    SUM(IFNULL(hdct.so_luong, 0)) AS so_luong_dich_vu_di_kem
FROM
    hop_dong hd
        LEFT JOIN
    hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong
GROUP BY hd.ma_hop_dong
ORDER BY hd.ma_hop_dong;

-- 11 	Hiển thị thông tin các dịch vụ đi kèm đã được sử dụng bởi những khách hàng có ten_loai_khach là “Diamond” và có dia_chi ở “Vinh” hoặc “Quảng Ngãi”.
SELECT 
    dvdk.ma_dich_vu_di_kem, dvdk.ten_dich_vu_di_kem
FROM
    dich_vu_di_kem dvdk
        JOIN
    hop_dong_chi_tiet hdct ON dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
        JOIN
    hop_dong hd ON hd.ma_hop_dong = hdct.ma_hop_dong
        JOIN
    khach_hang kh ON kh.ma_khach_hang = hd.ma_khach_hang
        JOIN
    loai_khach lk ON lk.ma_loai_khach = kh.ma_loai_khach
WHERE
    ten_loai_khach = 'Diamond'
        AND dia_chi LIKE '%Vinh'
        OR dia_chi LIKE '%Quảng Ngãi';

-- 12	Hiển thị thông tin ma_hop_dong, ho_ten (nhân viên), ho_ten (khách hàng), so_dien_thoai (khách hàng), ten_dich_vu, so_luong_dich_vu_di_kem 
-- (được tính dựa trên việc sum so_luong ở dich_vu_di_kem), tien_dat_coc
--  của tất cả các dịch vụ đã từng được khách hàng đặt vào 3 tháng cuối năm 2020 nhưng chưa từng được khách hàng đặt vào 6 tháng đầu năm 2021.

SELECT 
    hd.ma_hop_dong,
    nv.ho_va_ten,
    kh.ho_ten,
    kh.so_dien_thoai,
    dv.ten_dich_vu,
    SUM(IFNULL(hdct.so_luong, 0)) AS so_luong_dich_vu_di_kem,
    hd.tien_dat_coc
FROM
    hop_dong hd
        JOIN
    nhan_vien nv ON hd.ma_nhan_vien = nv.ma_nhan_vien
        JOIN
    khach_hang kh ON hd.ma_khach_hang = kh.ma_khach_hang
        JOIN
    dich_vu dv ON hd.ma_dich_vu = dv.ma_dich_vu
        LEFT JOIN
    hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong
WHERE
    hd.ma_hop_dong IN (SELECT 
            hd.ma_hop_dong
        FROM
            hop_dong
        WHERE
            MONTH(hd.ngay_lam_hop_dong) BETWEEN 10 AND 12
                AND YEAR(hd.ngay_lam_hop_dong) = 2020)
        AND hd.ma_hop_dong NOT IN (SELECT 
            hd.ma_hop_dong
        FROM
            hop_dong
        WHERE
            MONTH(hd.ngay_lam_hop_dong) BETWEEN 1 AND 6
                AND YEAR(hd.ngay_lam_hop_dong) = 2021)
GROUP BY hd.ma_hop_dong;

-- 13	Hiển thị thông tin các Dịch vụ đi kèm được sử dụng nhiều nhất bởi các Khách hàng đã đặt phòng.
-- (Lưu ý là có thể có nhiều dịch vụ có số lần sử dụng nhiều như nhau).
SELECT 
    dvdk.ma_dich_vu_di_kem,
    dvdk.ten_dich_vu_di_kem,
    SUM(hdct.so_luong) AS so_luong_dich_vu_di_kem
FROM
    dich_vu_di_kem dvdk
        JOIN
    hop_dong_chi_tiet hdct ON dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
GROUP BY dvdk.ma_dich_vu_di_kem , dvdk.ten_dich_vu_di_kem
HAVING so_luong_dich_vu_di_kem >= (SELECT 
        MAX(hop_dong_chi_tiet.so_luong)
    FROM
        hop_dong_chi_tiet);

-- 14	Hiển thị thông tin tất cả các Dịch vụ đi kèm chỉ mới được sử dụng một lần duy nhất.
-- Thông tin hiển thị bao gồm ma_hop_dong, ten_loai_dich_vu, ten_dich_vu_di_kem, so_lan_su_dung (được tính dựa trên việc count các ma_dich_vu_di_kem).
set sql_mode=(select replace(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT 
    hd.ma_hop_dong,
    ldv.ten_loai_dich_vu,
    dvdk.ten_dich_vu_di_kem,
    COUNT(dvdk.ma_dich_vu_di_kem) AS so_lan_su_dung
FROM
    dich_vu dv
        JOIN
    loai_dich_vu ldv ON dv.ma_loai_dich_vu = ldv.ma_loai_dich_vu
        JOIN
    hop_dong hd ON dv.ma_dich_vu = hd.ma_dich_vu
        JOIN
    hop_dong_chi_tiet hdct ON hd.ma_hop_dong = hdct.ma_hop_dong
        JOIN
    dich_vu_di_kem dvdk ON dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
GROUP BY dvdk.ten_dich_vu_di_kem
HAVING so_lan_su_dung = 1
ORDER BY hd.ma_hop_dong;


-- 15 Hiển thi thông tin của tất cả nhân viên bao gồm ma_nhan_vien, ho_ten, ten_trinh_do, ten_bo_phan, so_dien_thoai, dia_chi mới 
-- chỉ lập được tối đa 3 hợp đồng từ năm 2020 đến 2021.
-- so_lan_lap_hd < 4 and 
SELECT 
    nv.ma_nhan_vien,
    nv.ho_va_ten,
    td.ten_trinh_do,
    bp.ten_bo_phan,
    nv.so_dien_thoai,
    nv.dia_chi,
    COUNT(hd.ma_hop_dong) AS so_lan_lap_hd
FROM
    nhan_vien nv
        JOIN
    trinh_do td ON nv.ma_trinh_do = td.ma_trinh_do
        JOIN
    bo_phan bp ON nv.ma_bo_phan = bp.ma_bo_phan
        JOIN
    hop_dong hd ON hd.ma_nhan_vien = nv.ma_nhan_vien
WHERE
    YEAR(hd.ngay_lam_hop_dong) BETWEEN 2020 AND 2021
GROUP BY nv.ma_nhan_vien , nv.ho_va_ten , td.ten_trinh_do , bp.ten_bo_phan , nv.so_dien_thoai , nv.dia_chi
HAVING so_lan_lap_hd < 4
ORDER BY nv.ma_nhan_vien;

-- 16	Xóa những Nhân viên chưa từng lập được hợp đồng nào từ năm 2019 đến năm 2021.
delete from nhan_vien nv
where nv.ma_nhan_vien not in 
(select ma_nhan_vien from hop_dong hd
where year(hd.ngay_lam_hop_dong) between 2019 and 2021);

SELECT 
    *
FROM
    nhan_vien;

-- 17	Cập nhật thông tin những khách hàng có ten_loai_khach từ Platinum lên Diamond, 
-- chỉ cập nhật những khách hàng đã từng đặt phòng với Tổng Tiền thanh toán trong năm 2021 là lớn hơn 10.000.000 VNĐ.
CREATE VIEW view_tong_tien AS
    SELECT 
        kh.ma_khach_hang,
        lk.ten_loai_khach,
        SUM(IFNULL(dv.chi_phi_thue, 0) + IFNULL(hdct.so_luong, 0) * IFNULL(dvdk.gia, 0)) AS tong_tien
    FROM
        khach_hang kh
            JOIN
        loai_khach lk ON lk.ma_loai_khach = kh.ma_loai_khach
            JOIN
        hop_dong hd ON hd.ma_khach_hang = kh.ma_khach_hang
            JOIN
        dich_vu dv ON dv.ma_dich_vu = hd.ma_dich_vu
            JOIN
        hop_dong_chi_tiet hdct ON hdct.ma_hop_dong = hd.ma_hop_dong
            JOIN
        dich_vu_di_kem dvdk ON dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
    WHERE
        lk.ten_loai_khach = 'Platinium'
            AND YEAR(ngay_lam_hop_dong) = 2021
    GROUP BY lk.ma_loai_khach , kh.ma_khach_hang;
UPDATE khach_hang 
SET 
    ma_loai_khach = 1
WHERE
    ma_khach_hang = (SELECT 
            view_tong_tien.ma_khach_hang
        FROM
            view_tong_tien
        WHERE
            view_tong_tien.tong_tien > '1000000'
                AND ten_loai_khach = 'Platinium');

-- 	18 Xóa những khách hàng có hợp đồng trước năm 2021 (chú ý ràng buộc giữa các bảng).
SET foreign_key_checks = 0;
DELETE FROM khach_hang kh 
WHERE kh.ma_khach_hang IN (SELECT hd.ma_khach_hang FROM hop_dong hd WHERE YEAR(hd.ngay_lam_hop_dong) < 2021);
SELECT 
    *
FROM
    khach_hang;
    
    
-- 19	Cập nhật giá cho các dịch vụ đi kèm được sử dụng trên 10 lần trong năm 2020 lên gấp đôi.

 -- 20	Hiển thị thông tin của tất cả các nhân viên và khách hàng có trong hệ thống, thông tin hiển thị bao gồm id 
 -- (ma_nhan_vien, ma_khach_hang), ho_ten, email, so_dien_thoai, ngay_sinh, dia_chi.
SELECT 
    khach_hang.ma_khach_hang AS id,
    khach_hang.ho_ten,
    khach_hang.email,
    khach_hang.so_dien_thoai,
    khach_hang.ngay_sinh,
    khach_hang.dia_chi
FROM
    khach_hang 
UNION ALL SELECT 
    nhan_vien.ma_nhan_vien AS id,
    nhan_vien.ho_va_ten,
    nhan_vien.email,
    nhan_vien.so_dien_thoai,
    nhan_vien.ngay_sinh,
    dia_chi
FROM
    nhan_vien;
 
 
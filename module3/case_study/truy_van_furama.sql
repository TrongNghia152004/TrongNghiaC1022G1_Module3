USE database_furama;
--  Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự.
SELECT 
    *
FROM
    nhan_vien
WHERE
    CHAR_LENGTH(nhan_vien.ho_va_ten) <= 15
        AND (nhan_vien.ho_va_ten LIKE 'H%'
        OR nhan_vien.ho_va_ten LIKE 'T%'
        OR nhan_vien.ho_va_ten LIKE 'K%');
--  Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
SELECT 
    *
FROM
    khach_hang
WHERE
    (khach_hang.dia_chi LIKE '% Quảng Trị'
        OR khach_hang.dia_chi LIKE '% Đà Nẵng')
        AND YEAR(CURRENT_DATE()) - YEAR(ngay_sinh) BETWEEN 18 AND 50;
 -- Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần. 
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
-- Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien 
-- (Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) 
-- cho tất cả các khách hàng đã từng đặt phòng.
-- (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra).
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select khach_hang.ma_khach_hang , khach_hang.ho_ten , loai_khach.ten_loai_khach , hop_dong.ma_hop_dong , dich_vu.ten_dich_vu , hop_dong.ngay_lam_hop_dong ,
hop_dong.ngay_ket_thuc , sum(ifnull(dich_vu.chi_phi_thue,0)+ifnull(hop_dong_chi_tiet.so_luong,0)*ifnull(dich_vu_di_kem.gia,0)) as 'tong_tien' from khach_hang
left join loai_khach on khach_hang.ma_loai_khach = loai_khach.ma_loai_khach
left join hop_dong on khach_hang.ma_khach_hang = hop_dong.ma_khach_hang
left join dich_vu on hop_dong.ma_dich_vu = dich_vu.ma_dich_vu
left join hop_dong_chi_tiet on hop_dong.ma_hop_dong = hop_dong_chi_tiet.ma_hop_dong
left join dich_vu_di_kem on hop_dong_chi_tiet.ma_dich_vu_di_kem = dich_vu_di_kem.ma_dich_vu_di_kem
group by ma_hop_dong;
CREATE SCHEMA quan_ly_vat_tu;
USE quan_ly_vat_tu;
CREATE TABLE phieu_xuat (
    so_phieu_xuat INT PRIMARY KEY,
    ngay_xuat DATE NOT NULL
);
CREATE TABLE vat_tu (
    ma_vat_tu INT PRIMARY KEY,
    ten_vat_tu VARCHAR(50) NOT NULL
);
CREATE TABLE phieu_nhap (
    so_phieu_nhap INT PRIMARY KEY,
    ngay_nhap DATE NOT NULL
);
CREATE TABLE nha_cung_cap (
    ma_nha_cung_cap INT PRIMARY KEY,
    ten_nha_cung_cap VARCHAR(50) NOT NULL,
    dia_chi VARCHAR(50) NOT NULL
);
CREATE TABLE don_dat_hang (
    so_don_hang INT PRIMARY KEY,
    ngay_dat_hang DATE NOT NULL,
    ma_nha_cung_cap INT NOT NULL,
    CONSTRAINT fk_nha_cung_cap_don_dat_hang FOREIGN KEY (ma_nha_cung_cap)
        REFERENCES nha_cung_cap (ma_nha_cung_cap)
);
CREATE TABLE so_dien_thoai (
    ma_so_dien_thoai VARCHAR(50) PRIMARY KEY,
    ma_nha_cung_cap INT NOT NULL,
    CONSTRAINT fk_nha_cung_cap_so_dien_thoai FOREIGN KEY (ma_nha_cung_cap)
        REFERENCES nha_cung_cap (ma_nha_cung_cap)
);
CREATE TABLE chi_tiet_phieu_xuat (
    so_phieu_xuat INT NOT NULL,
    ma_vat_tu INT NOT NULL,
    don_gia_xuat INT NOT NULL,
    so_luong_xuat INT NOT NULL,
    PRIMARY KEY (so_phieu_xuat , ma_vat_tu),
    CONSTRAINT fk_so_phieu_xuat_chi_tiet_phieu_xuat FOREIGN KEY (so_phieu_xuat)
        REFERENCES phieu_xuat (so_phieu_xuat),
    CONSTRAINT fk_ma_vat_tu_chi_tiet_phieu_xuat FOREIGN KEY (ma_vat_tu)
        REFERENCES vat_tu (ma_vat_tu)
);
CREATE TABLE chi_tiet_phieu_nhap (
    ma_vat_tu INT NOT NULL,
    so_phieu_nhap INT NOT NULL,
    don_gia_nhap INT NOT NULL,
    so_luong_nhap INT NOT NULL,
    PRIMARY KEY (ma_vat_tu , so_phieu_nhap),
    CONSTRAINT fk_ma_vat_tu_chi_tiet_phieu_nhap FOREIGN KEY (ma_vat_tu)
        REFERENCES vat_tu (ma_vat_tu),
    CONSTRAINT fk_so_phieu_nhap_chi_tiet_phieu_nhap FOREIGN KEY (so_phieu_nhap)
        REFERENCES phieu_nhap (so_phieu_nhap)
);
CREATE TABLE chi_tiet_don_dat_hang (
    ma_vat_tu INT NOT NULL,
    so_don_hang INT NOT NULL,
    PRIMARY KEY (ma_vat_tu , so_don_hang),
    CONSTRAINT fk_ma_vat_tu_chi_tiet_don_dat_hang FOREIGN KEY (ma_vat_tu)
        REFERENCES vat_tu (ma_vat_tu),
    CONSTRAINT fk_so_don_hang_chi_tiet_don_dat_hang FOREIGN KEY (so_don_hang)
        REFERENCES don_dat_hang (so_don_hang)
);
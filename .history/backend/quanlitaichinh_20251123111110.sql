-- ============================
-- XÓA DATABASE CŨ (nếu có) và tạo mới
-- ============================
DROP DATABASE IF EXISTS quanly_taichinh;
CREATE DATABASE quanly_taichinh;
USE quanly_taichinh;

-- ============================
-- BẢNG NGƯỜI DÙNG
-- ============================
DROP TABLE IF EXISTS nguoi_dung;
CREATE TABLE nguoi_dung (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ho_ten VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    so_dien_thoai VARCHAR(20) NOT NULL UNIQUE,
    mat_khau VARCHAR(255) NOT NULL,
    ngay_sinh DATE NULL,
    gioi_tinh VARCHAR(20) NULL,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- BẢNG TÀI KHOẢN (VÍ, TIỀN MẶT...)
-- ============================
DROP TABLE IF EXISTS tai_khoan;
CREATE TABLE tai_khoan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    ten_tai_khoan VARCHAR(100) NOT NULL,
    loai_tai_khoan VARCHAR(50) NOT NULL,
    so_du DECIMAL(18,2) DEFAULT 0,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_taikhoan_nguoidung FOREIGN KEY (nguoi_dung_id)
        REFERENCES nguoi_dung(id) ON DELETE CASCADE
);

-- ============================
-- BẢNG DANH MỤC (CATEGORY)
-- ============================
DROP TABLE IF EXISTS danh_muc;
CREATE TABLE danh_muc (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten_danh_muc VARCHAR(150) NOT NULL,
    loai VARCHAR(10) NOT NULL,
    icon VARCHAR(100) NULL,
    CONSTRAINT chk_loai_dm CHECK (loai IN ('Thu', 'Chi'))
);

-- ============================
-- BẢNG GIAO DỊCH
-- ============================
DROP TABLE IF EXISTS giao_dich;
CREATE TABLE giao_dich (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    tai_khoan_id INT NOT NULL,
    danh_muc_id INT NOT NULL,
    loai_gd VARCHAR(10) NOT NULL,
    so_tien DECIMAL(18,2) NOT NULL,
    mo_ta VARCHAR(500) NULL,
    ngay_giao_dich DATETIME NOT NULL,
    anh_hoa_don VARCHAR(255) NULL,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_gd_nguoidung FOREIGN KEY (nguoi_dung_id)
        REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    CONSTRAINT FK_gd_taikhoan FOREIGN KEY (tai_khoan_id)
        REFERENCES tai_khoan(id) ON DELETE CASCADE,
    CONSTRAINT FK_gd_danhmuc FOREIGN KEY (danh_muc_id)
        REFERENCES danh_muc(id) ON DELETE NO ACTION,
    CONSTRAINT chk_loai_gd CHECK (loai_gd IN ('Thu', 'Chi'))
);

-- ============================
-- BẢNG NGÂN SÁCH (BUDGET)
-- ============================
DROP TABLE IF EXISTS ngan_sach;
CREATE TABLE ngan_sach (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    danh_muc_id INT NULL,
    so_tien_gioi_han DECIMAL(18,2) NOT NULL,
    chu_ky VARCHAR(20) NOT NULL,
    ngay_bat_dau DATE NOT NULL,
    ngay_ket_thuc DATE NULL,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_budget_user FOREIGN KEY (nguoi_dung_id)
        REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    CONSTRAINT FK_budget_cat FOREIGN KEY (danh_muc_id)
        REFERENCES danh_muc(id) ON DELETE SET NULL,
    CONSTRAINT chk_chuky CHECK (chu_ky IN ('Tháng','Tuần','Ngày'))
);

-- ============================
-- BẢNG THÔNG BÁO
-- ============================
DROP TABLE IF EXISTS thong_bao;
CREATE TABLE thong_bao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    noi_dung TEXT NOT NULL,
    loai VARCHAR(50) NOT NULL,
    da_doc BIT DEFAULT 0,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_tb_user FOREIGN KEY (nguoi_dung_id)
        REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    CONSTRAINT chk_loai_tb CHECK (loai IN ('Cảnh báo','Gợi ý'))
);

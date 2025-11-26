
CREATE DATABASE quanly_taichinh
GO
USE quanly_taichinh;
GO

CREATE TABLE nguoi_dung (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ho_ten NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    so_dien_thoai NVARCHAR(20) NOT NULL UNIQUE,
    mat_khau NVARCHAR(255) NOT NULL,
    ngay_sinh DATE NULL,
    gioi_tinh NVARCHAR(20) NULL,
    anh_dai_dien NVARCHAR(255) NULL,
    ngay_tao DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE tai_khoan (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    ten_tai_khoan NVARCHAR(100) NOT NULL,
    loai_tai_khoan NVARCHAR(50) NOT NULL CHECK (loai_tai_khoan IN (N'Tiền mặt', N'Ngân hàng', N'Thẻ tín dụng', N'Ví điện tử')),
    so_du DECIMAL(18,2) DEFAULT 0,
    ngay_tao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_taikhoan_nguoidung FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(id) ON DELETE CASCADE
);
GO

CREATE TABLE han_muc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_han_muc NVARCHAR(150) NOT NULL,
    loai NVARCHAR(50) NOT NULL CHECK (loai IN (N'Thu nhập', N'Chi tiêu', N'Cho vay', N'Đi vay', N'Khác'))
);
GO


CREATE TABLE giao_dich (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    tai_khoan_id INT NOT NULL,
    han_muc_id INT NOT NULL,
    loai_gd NVARCHAR(50) NOT NULL CHECK (loai_gd IN (N'Thu', N'Chi', N'Cho vay', N'Đi vay')),
    so_tien DECIMAL(18,2) NOT NULL,
    mo_ta NVARCHAR(500) NULL,
    ngay_giao_dich DATE NOT NULL,
    ngay_tao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_gd_taikhoan FOREIGN KEY (tai_khoan_id) REFERENCES tai_khoan(id) ON DELETE CASCADE,
    CONSTRAINT FK_gd_nguoidung FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(id) ON DELETE NO ACTION,
    CONSTRAINT FK_gd_hanmuc FOREIGN KEY (han_muc_id) REFERENCES han_muc(id) ON DELETE NO ACTION
);
GO

CREATE TABLE han_muc_chi_tieu (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    han_muc_id INT NULL,
    so_tien_gioi_han DECIMAL(18,2) NOT NULL,
    chu_ky NVARCHAR(20) NOT NULL CHECK (chu_ky IN (N'Theo ngày', N'Theo tuần', N'Theo tháng')),
    ngay_bat_dau DATE NOT NULL,
    ngay_ket_thuc DATE NULL,
    ngay_tao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_budget_user FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    CONSTRAINT FK_budget_cat FOREIGN KEY (han_muc_id) REFERENCES han_muc(id) ON DELETE SET NULL
);
GO

CREATE TABLE thong_bao (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    noi_dung NVARCHAR(MAX) NOT NULL,
    loai NVARCHAR(50) NOT NULL CHECK (loai IN (N'Cảnh báo', N'Gợi ý')),
    da_doc BIT DEFAULT 0,
    ngay_tao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_tb_user FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(id) ON DELETE CASCADE
);
GO

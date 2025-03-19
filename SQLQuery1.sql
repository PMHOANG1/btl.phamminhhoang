CREATE DATABASE QL_CH_NGK;
GO
USE QL_CH_NGK;
GO

DROP TABLE ChiTietHoaDon;
DROP TABLE PhieuGiaoHang;
DROP TABLE SanPham;
DROP TABLE HoaDon;
DROP TABLE DatHang;
DROP TABLE KhachHang;
DROP TABLE NhaCungCap;

CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY,
    TenKH NVARCHAR(50) NOT NULL,
    DiaChi NVARCHAR(100),
    SoDT VARCHAR(15)
);
GO

CREATE TABLE SanPham (
    MaSP INT PRIMARY KEY,
    TenSP NVARCHAR(50) NOT NULL,
    LoaiNuoc NVARCHAR(30) NOT NULL,
    Hieu NVARCHAR(30) NOT NULL,
    GiaBan DECIMAL(10, 2) NOT NULL
);
GO

CREATE TABLE HoaDon (
    MaHD INT PRIMARY KEY,
    MaKH INT,
    NgayLap DATE NOT NULL,
    TongTien DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
GO

CREATE TABLE ChiTietHoaDon (
    MaHD INT,
    MaSP INT,
    SoLuong INT NOT NULL,
    ThanhTien DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (MaHD, MaSP),
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
GO

CREATE TABLE NhaCungCap (
    MaNCC INT PRIMARY KEY,
    TenNCC NVARCHAR(50) NOT NULL,
    DiaChi NVARCHAR(100),
    SoDT VARCHAR(15)
);
GO

CREATE TABLE DatHang (
    MaDH INT PRIMARY KEY,
    MaNCC INT,
    NgayDat DATE NOT NULL,
    TongTien DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);
GO

CREATE TABLE PhieuGiaoHang (
    MaPGH INT PRIMARY KEY,
    MaDH INT,
    NgayGiao DATE NOT NULL,
    SoLuongGiao INT NOT NULL,
    DonGia DECIMAL(10, 2) NOT NULL,
    ThanhTien DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (MaDH) REFERENCES DatHang(MaDH)
);
GO

-- 2. Truy vấn INSERT
-- Chèn dữ liệu vào bảng KhachHang
INSERT INTO KhachHang (MaKH, TenKH, DiaChi, SoDT)
VALUES
(1, N'Nguyễn văn A', N'Hà Nội, Việt Nam', '0123456789'),
(2, N'Trần Thị B', N'Hồ Chí Minh, Việt Nam', '0987654321'),
(3, N'Lê Quang C', N'Đà Nẵng, Việt Nam', '0345678901');
GO

-- Chèn dữ liệu vào bảng SanPham
INSERT INTO SanPham (MaSP, TenSP, LoaiNuoc, Hieu, GiaBan)
VALUES
(11, N'Nước Cam Tribeco', N'Nước cam', N'Tribeco', 15.00),
(21, N'Nước suối nóng', N'Nước suối', N'Rung Hương', 10.00),
(31, N'Bia Tiger', 'Bia', N'Tiger', 20.00),
(41, N'Nước ngọt Coca', N'Nước ngọt', N'Coca Cola', 12.00);
GO

-- Chèn dữ liệu vào bảng HoaDon
INSERT INTO HoaDon (MaHD, MaKH, NgayLap, TongTien)
VALUES
(12, 1, '2025-03-15', 45.00),
(22, 2, '2025-03-15', 72.00),
(32, 3, '2025-03-16', 60.00);
GO

-- Chèn dữ liệu vào bảng ChiTietHoaDon
INSERT INTO ChiTietHoaDon (MaHD, MaSP, SoLuong, ThanhTien)
VALUES
(12, 11, 2, 30.00), 
(12, 31, 1, 15.00), 
(22, 21, 3, 30.00),  
(22, 41, 2, 24.00), 
(32, 11, 1, 15.00), 
(32, 21, 2, 20.00);  
GO

-- Chèn dữ liệu vào bảng NhaCungCap
INSERT INTO NhaCungCap (MaNCC, TenNCC, DiaChi, SoDT)
VALUES
(15, N'Công Ty Nước Tribeco', N'Hà Nội, Việt Nam', '01123456789'),
(25, N'Công Ty Nước Rung Hương', N'Hồ Chí Minh, Việt Nam', '02123456789');
GO

-- Chèn dữ liệu vào bảng DatHang
INSERT INTO DatHang (MaDH, MaNCC, NgayDat, TongTien)
VALUES
(16, 15, '2025-03-16', 300.00),
(26, 25, '2025-03-16', 180.00);
GO

-- Chèn dữ liệu vào bảng PhieuGiaoHang
INSERT INTO PhieuGiaoHang (MaPGH, MaDH, NgayGiao, SoLuongGiao, DonGia, ThanhTien) 
VALUES
(18, 16, '2025-04-17', 20, 15.00, 300.00),
(28, 26, '2025-04-19', 15, 12.00, 180.00);
GO

-- 1. Truy vấn SELECT
SELECT * FROM KhachHang;
SELECT * FROM SanPham;
SELECT * FROM HoaDon;
SELECT * FROM ChiTietHoaDon;
SELECT * FROM DatHang;
SELECT * FROM PhieuGiaoHang;
SELECT * FROM NhaCungCap;

-- Lấy danh sách hóa đơn của một khách hàng cụ thể:
SELECT * FROM HoaDon WHERE MaKH = 1;

--Lấy chi tiết hóa đơn kèm theo thông tin sản phẩm:
SELECT ch.MaHD, sp.TenSP, ch.SoLuong, ch.ThanhTien
FROM ChiTietHoaDon ch inner join SanPham sp ON ch.MaSP = sp.MaSP
WHERE ch.MaHD = 12;

--3. Truy vấn UPDATE
--Cập nhật số điện thoại của khách hàng:
UPDATE KhachHang
SET SoDT = '0999888777'
WHERE MaKH = 2;

--Cập nhật giá bán của một sản phẩm:
UPDATE SanPham
SET GiaBan = 20.00
WHERE MaSP = 21;

--Cập nhật số lượng sản phẩm trong chi tiết hóa đơn:
UPDATE ChiTietHoaDon
SET SoLuong = 5, ThanhTien = 90.00
WHERE MaHD = 22 AND MaSP = 21;

--4. Truy vấn DELETE
--Xóa một sản phẩm 
-- Trước khi ta xóa mã khách hàng 3 ta cần xóa tất cả dữ liệu liên quan trước khi xóa khách hàng ko bị lỗi
DELETE FROM ChiTietHoaDon WHERE MaHD IN (SELECT MaHD FROM HoaDon WHERE MaKH = 3);
GO
DELETE FROM HoaDon WHERE MaKH = 3;
GO
DELETE FROM KhachHang WHERE MaKH = 3;





----**Truy vấn nâng cao (INNER JOIN, GROUP BY, HAVING, SUBQUERY)
--1. Sử dụng INNER JOIN - Danh sách hóa đơn kèm thông tin khách hàng
SELECT h.MaHD, h.NgayLap, h.TongTien, k.TenKH, k.DiaChi, k.SoDT
FROM HoaDon h INNER JOIN KhachHang k ON h.MaKH = k.MaKH;

--Danh sách hóa đơn kèm thông tin sản phẩm
SELECT h.MaHD, h.NgayLap, k.TenKH, sp.TenSP, cthd.SoLuong, sp.GiaBan, cthd.ThanhTien
FROM HoaDon h INNER JOIN KhachHang k ON h.MaKH = k.MaKH
			  INNER JOIN ChiTietHoaDon cthd ON h.MaHD = cthd.MaHD
			  INNER JOIN SanPham sp ON cthd.MaSP = sp.MaSP;

--2. GROUP BY - Tổng số tiền mà mỗi khách hàng đã chi tiêu
SELECT k.MaKH, k.TenKH, SUM(h.TongTien) AS TongChiTieu
FROM HoaDon h INNER JOIN KhachHang k ON h.MaKH = k.MaKH
GROUP BY k.MaKH, k.TenKH;

--Số lượng sản phẩm đã bán theo từng loại nước
SELECT sp.LoaiNuoc, SUM(cthd.SoLuong) AS TongSoLuong
FROM ChiTietHoaDon cthd INNER JOIN SanPham sp ON cthd.MaSP = sp.MaSP
GROUP BY sp.LoaiNuoc;

--3. HAVING - Danh sách khách hàng có tổng chi tiêu trên 50K
SELECT k.MaKH, k.TenKH, SUM(h.TongTien) AS TongChiTieu
FROM HoaDon h INNER JOIN KhachHang k ON h.MaKH = k.MaKH
GROUP BY k.MaKH, k.TenKH
HAVING SUM(h.TongTien) > 50;

--Sản phẩm có doanh thu trên 20K
SELECT sp.TenSP, SUM(cthd.ThanhTien) AS DoanhThu
FROM ChiTietHoaDon cthd INNER JOIN SanPham sp ON cthd.MaSP = sp.MaSP
GROUP BY sp.TenSP
HAVING SUM(cthd.ThanhTien) > 20;

--4. SUBQUERY - Danh sách khách hàng đã từng mua "Nước Cam Tribeco"
SELECT DISTINCT k.MaKH, k.TenKH
FROM KhachHang k
WHERE k.MaKH IN (
    SELECT h.MaKH 
    FROM HoaDon h INNER JOIN ChiTietHoaDon cthd ON h.MaHD = cthd.MaHD
				  INNER JOIN SanPham sp ON cthd.MaSP = sp.MaSP
    WHERE sp.TenSP = 'Nuoc Cam Tribeco'
);

--Khách hàng chưa từng mua hàng
SELECT k.MaKH, k.TenKH
FROM KhachHang k
WHERE NOT EXISTS (
    SELECT 1 FROM HoaDon h WHERE h.MaKH = k.MaKH
);



----CHƯƠNG 5
--Tạo người dùng
--1️ Tạo Login ở cấp Server
CREATE LOGIN NguoiDungDE10 WITH PASSWORD = 'MatKhauManh@123';

--2. Tạo User trong Database
USE QL_CH_NGK;  
CREATE USER NguoiDungDE10 FOR LOGIN NguoiDungDE10;

--3. Cấp quyền cho User
--Chỉ đọc dữ liệu
ALTER ROLE db_datareader ADD MEMBER NguoiDungDE10;
-- thể chỉnh sửa dữ liệu
ALTER ROLE db_datawriter ADD MEMBER NguoiDungDE10;
--Toàn quyền trong database
ALTER ROLE db_owner ADD MEMBER NguoiDungMoi;

-- Thiết lập các quyền truy cập và phân quyền người dùng
--1️. Tạo Login cấp Server
CREATE LOGIN NguoiDungA WITH PASSWORD = 'MatKhau@123';

--2️. Tạo User trong Database
USE QL_CH_NGK; 
CREATE USER NguoiDungA FOR LOGIN NguoiDungA;

--3. Phân quyền cho người dùng
--Chỉ đọc dữ liệu (SELECT)
GRANT SELECT ON DATABASE::QL_CH_NGK TO NguoiDungA;
--Chỉ được cập nhật dữ liệu (INSERT, UPDATE, DELETE)
GRANT INSERT, UPDATE, DELETE ON DATABASE::QL_CH_NGK TO NguoiDungA;
--Cấp quyền theo vai trò
ALTER ROLE db_datareader ADD MEMBER NguoiDungA;
--Có thể chỉnh sửa dữ liệu (db_datawriter)
ALTER ROLE db_datawriter ADD MEMBER NguoiDungA;
--Toàn quyền trên database (db_owner)
ALTER ROLE db_owner ADD MEMBER NguoiDungA;

--4️. Thu hồi quyền
--Thu hồi quyền SELECT trên database
REVOKE SELECT ON DATABASE::QL_CH_NGK FROM NguoiDungA;
--Xóa người dùng khỏi vai trò
ALTER ROLE db_datareader DROP MEMBER NguoiDungA;

--5. Xóa User trong Database
USE QL_CH_NGK;
DROP USER NguoiDungA;
--Xóa Login cấp Server
DROP LOGIN NguoiDungA;


---	Quản lý sao lưu và phục hồi dữ liệu
--1️ Sao lưu dữ liệu (Backup Database)
BACKUP DATABASE QL_CH_NGK  
TO DISK = 'D:\Backup\QL_CH_NGK_FULL.bak'
WITH FORMAT, INIT, NAME = 'Full Backup QL_CH_NGK';
--2️. Phục hồi dữ liệu (Restore Database)
RESTORE DATABASE QL_CH_NGK  
FROM DISK = 'D:\Backup\QL_CH_NGK_FULL.bak'  
WITH REPLACE, RECOVERY;
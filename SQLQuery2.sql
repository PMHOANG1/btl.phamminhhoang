USE QL_CH_NGK;
GO

--Tạo 7- 10 view từ cơ bản đến nâng cao
--1. View cơ bản - Danh sách khách hàng
CREATE VIEW v_DanhSachKhachHang AS
SELECT MaKH, TenKH, DiaChi, SoDT
FROM KhachHang;

SELECT * FROM v_DanhSachKhachHang;

--2. View cơ bản - Danh sách sản phẩm
CREATE VIEW v_DanhSachSanPham AS
SELECT MaSP, TenSP, LoaiNuoc, Hieu, GiaBan
FROM SanPham;

SELECT * FROM v_DanhSachSanPham;

--3. View trung cấp - Danh sách hóa đơn kèm thông tin khách hàng
CREATE VIEW v_HoaDonKhachHang AS
SELECT h.MaHD, h.NgayLap, h.TongTien, k.TenKH, k.DiaChi, k.SoDT
FROM HoaDon h INNER JOIN KhachHang k ON h.MaKH = k.MaKH;

SELECT * FROM v_HoaDonKhachHang;

--4. View trung cấp - Chi tiết hóa đơn kèm sản phẩm
CREATE VIEW v_ChiTietHoaDon AS
SELECT h.MaHD, k.TenKH, sp.TenSP, cthd.SoLuong, sp.GiaBan, cthd.ThanhTien
FROM ChiTietHoaDon cthd INNER JOIN HoaDon h ON cthd.MaHD = h.MaHD
						INNER JOIN KhachHang k ON h.MaKH = k.MaKH
						INNER JOIN SanPham sp ON cthd.MaSP = sp.MaSP;

SELECT * FROM v_ChiTietHoaDon;

--5. View nâng cao - Tổng số tiền khách hàng đã chi tiêu
CREATE VIEW v_TongChiTieuKhachHang AS
SELECT k.MaKH, k.TenKH, SUM(h.TongTien) AS TongChiTieu
FROM HoaDon h INNER JOIN KhachHang k ON h.MaKH = k.MaKH
GROUP BY k.MaKH, k.TenKH;

SELECT * FROM v_TongChiTieuKhachHang;

--6. View nâng cao - Tổng số lượng sản phẩm đã bán theo loại nước
CREATE VIEW v_TongSanPhamDaBan AS
SELECT sp.LoaiNuoc, SUM(cthd.SoLuong) AS TongSoLuong
FROM ChiTietHoaDon cthd INNER JOIN SanPham sp ON cthd.MaSP = sp.MaSP
GROUP BY sp.LoaiNuoc;

SELECT * FROM v_TongSanPhamDaBan;

--7. View nâng cao - Khách hàng đã từng mua "Nước Cam Tribeco"
CREATE VIEW v_KhachMuaNuocCam AS
SELECT DISTINCT k.MaKH, k.TenKH
FROM KhachHang k
WHERE k.MaKH IN (
    SELECT h.MaKH 
    FROM HoaDon h INNER JOIN ChiTietHoaDon cthd ON h.MaHD = cthd.MaHD
				  INNER JOIN SanPham sp ON cthd.MaSP = sp.MaSP
    WHERE sp.TenSP = 'Nuoc Cam Tribeco'
);

SELECT * FROM v_KhachMuaNuocCam;



---Tạo 7-10 index cần thiết cho các bảng
--1. Index trên khóa chính bảng KhachHang
CREATE INDEX idx_KhachHang_MaKH ON KhachHang(MaKH);

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('KhachHang');

--2. Index trên khóa chính bảng SanPham
CREATE INDEX idx_SanPham_MaSP ON SanPham(MaSP);

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('SanPham');

--3. Index trên khóa chính bảng HoaDon
CREATE INDEX idx_HoaDon_MaHD ON HoaDon(MaHD);

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('HoaDon');

--4. Index trên khóa ngoại bảng ChiTietHoaDon (MaHD, MaSP)
CREATE INDEX idx_ChiTietHoaDon_MaHD_MaSP ON ChiTietHoaDon(MaHD, MaSP);

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('ChiTietHoaDon');

--5. Index trên khóa chính bảng NhaCungCap
CREATE INDEX idx_NhaCungCap_MaNCC ON NhaCungCap(MaNCC);

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('NhaCungCap');

--6. Index trên khóa chính bảng DatHang
CREATE INDEX idx_DatHang_MaDH ON DatHang(MaDH);

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('DatHang');

--7. Index trên khóa chính bảng PhieuGiaoHang
CREATE INDEX idx_PhieuGiaoHang_MaPGH ON PhieuGiaoHang(MaPGH);

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('PhieuGiaoHang');



---Xây dựng 10 Stored Procedure(không tham số, có tham số, có OUTPUT)
--1. Stored Procedure không có tham số
--1.1. Lấy danh sách khách hàng
CREATE PROCEDURE sp_LayDanhSachKhachHang
AS
BEGIN
    SELECT * FROM KhachHang;
END;

EXEC sp_LayDanhSachKhachHang;

--1.2. Lấy danh sách hóa đơn
CREATE PROCEDURE sp_LayDanhSachHoaDon
AS
BEGIN
    SELECT * FROM HoaDon;
END;

EXEC sp_LayDanhSachHoaDon;

--2. Stored Procedure có tham số đầu vào (Input Parameters)
--2.1. Lấy thông tin khách hàng theo mã
CREATE PROCEDURE sp_LayKhachHangTheoMa
    @MaKH INT
AS
BEGIN
    SELECT * FROM KhachHang WHERE MaKH = @MaKH;
END;

EXEC sp_LayKhachHangTheoMa @MaKH = 1;

--2.2. Lấy danh sách sản phẩm theo loại nước
CREATE PROCEDURE sp_LaySanPhamTheoLoai
    @LoaiNuoc NVARCHAR(50)
AS
BEGIN
    SELECT * FROM SanPham WHERE LoaiNuoc = @LoaiNuoc;
END;

EXEC sp_LaySanPhamTheoLoai @LoaiNuoc = N'Bia';

--2.3. Thêm mới khách hàng
CREATE PROCEDURE sp_ThemKhachHang
    @MaKH INT, 
    @TenKH NVARCHAR(100), 
    @DiaChi NVARCHAR(255), 
    @SoDT NVARCHAR(20)
AS
BEGIN
    INSERT INTO KhachHang (MaKH, TenKH, DiaChi, SoDT) 
    VALUES (@MaKH, @TenKH, @DiaChi, @SoDT);
END;

EXEC sp_ThemKhachHang 4, N'Pham Van D', N'Hue, Vietnam', '0998765432';

--2.4. Cập nhật giá bán sản phẩm
CREATE PROCEDURE sp_CapNhatGiaSanPham
    @MaSP INT, 
    @GiaBan FLOAT
AS
BEGIN
    UPDATE SanPham SET GiaBan = @GiaBan WHERE MaSP = @MaSP;
END;

EXEC sp_CapNhatGiaSanPham 11, 18.00;

--2.5. Xóa hóa đơn theo mã
CREATE PROCEDURE sp_XoaHoaDon
    @MaHD INT
AS
BEGIN
    -- Xóa dữ liệu trong bảng ChiTietHoaDon trước
    DELETE FROM ChiTietHoaDon WHERE MaHD = @MaHD;

    -- Xóa dữ liệu trong bảng HoaDon
    DELETE FROM HoaDon WHERE MaHD = @MaHD;
END;

EXEC sp_XoaHoaDon 12;

--3. Stored Procedure có tham số đầu ra (Output Parameters)
--3.1. Đếm số lượng khách hàng
CREATE PROCEDURE sp_DemSoLuongKhachHang
    @SoLuongKH INT OUTPUT
AS
BEGIN
    SELECT @SoLuongKH = COUNT(*) FROM KhachHang;
END;

DECLARE @TongKH INT;
EXEC sp_DemSoLuongKhachHang @TongKH OUTPUT;
PRINT @TongKH;

--3.2. Tính tổng doanh thu
CREATE PROCEDURE sp_TinhTongDoanhThu
    @TongDoanhThu FLOAT OUTPUT
AS
BEGIN
    SELECT @TongDoanhThu = SUM(TongTien) FROM HoaDon;
END;

DECLARE @DoanhThu FLOAT;
EXEC sp_TinhTongDoanhThu @DoanhThu OUTPUT;
PRINT @DoanhThu;

--3.3. Kiểm tra tồn tại khách hàng
CREATE PROCEDURE sp_KiemTraKhachHang
    @MaKH INT,
    @TonTai BIT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM KhachHang WHERE MaKH = @MaKH)
        SET @TonTai = 1;
    ELSE
        SET @TonTai = 0;
END;

DECLARE @KetQua BIT;
EXEC sp_KiemTraKhachHang 1, @KetQua OUTPUT;
PRINT @KetQua;

--3.4. Lấy tổng số lượng sản phẩm đã bán theo mã sản phẩm
CREATE PROCEDURE sp_TongSoLuongSanPhamBan
    @MaSP INT,
    @TongSoLuong INT OUTPUT
AS
BEGIN
    SELECT @TongSoLuong = SUM(SoLuong) 
    FROM ChiTietHoaDon 
    WHERE MaSP = @MaSP;
END;

DECLARE @TongSoLuong INT;
EXEC sp_TongSoLuongSanPhamBan 11, @TongSoLuong OUTPUT;
PRINT @TongSoLuong;



---Tạo 10 function (trả về kiểu vô hướng, bảng, biến bảng)
--1️ Scalar Function - Trả về tổng tiền của hóa đơn
CREATE FUNCTION fn_TongTienHoaDon(@MaHD INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TongTien DECIMAL(10,2);
    SELECT @TongTien = SUM(ISNULL(ThanhTien, 0))
    FROM ChiTietHoaDon
    WHERE MaHD = @MaHD;
    RETURN @TongTien;
END;

SELECT dbo.fn_TongTienHoaDon(22) AS TongTien;

--2 Scalar Function - Tính số lượng sản phẩm trong hóa đơn
CREATE FUNCTION fn_SoLuongSanPham(@MaHD INT)
RETURNS INT
AS
BEGIN
    DECLARE @SoLuong INT;
    SELECT @SoLuong = SUM(SoLuong)
    FROM ChiTietHoaDon
    WHERE MaHD = @MaHD;
    RETURN @SoLuong;
END;

SELECT dbo.fn_SoLuongSanPham(22) AS TongSoLuong;

--3️ Inline Table-Valued Function - Lấy danh sách hóa đơn của một khách hàng
CREATE FUNCTION fn_DanhSachHoaDon(@MaKH INT)
RETURNS TABLE
AS
RETURN
(
    SELECT MaHD, NgayLap, TongTien
    FROM HoaDon
    WHERE MaKH = @MaKH
);

SELECT * FROM dbo.fn_DanhSachHoaDon(2);

--4️ Inline Table-Valued Function - Lấy danh sách sản phẩm có giá cao hơn giá nhập
CREATE FUNCTION fn_SanPhamGiaCao(@GiaMin DECIMAL(10,2))
RETURNS TABLE
AS
RETURN
(
    SELECT MaSP, TenSP, GiaBan
    FROM SanPham
    WHERE GiaBan > @GiaMin
);

SELECT * FROM dbo.fn_SanPhamGiaCao(15.00);

--5️ Multi-Statement Table-Valued Function - Lấy danh sách khách hàng đã mua hàng
CREATE FUNCTION fn_KhachHangMuaHang()
RETURNS @KhachHang TABLE (MaKH INT, TenKH NVARCHAR(100))
AS
BEGIN
    INSERT INTO @KhachHang
    SELECT DISTINCT KH.MaKH, KH.TenKH
    FROM KhachHang KH
    JOIN HoaDon HD ON KH.MaKH = HD.MaKH;
    RETURN;
END;

SELECT * FROM dbo.fn_KhachHangMuaHang();

--6 Multi-Statement Table-Valued Function - Danh sách sản phẩm bán chạy
CREATE FUNCTION fn_SanPhamBanChay(@SoLuongMin INT)
RETURNS @DanhSach TABLE (MaSP INT, TenSP NVARCHAR(100), TongSoLuong INT)
AS
BEGIN
    INSERT INTO @DanhSach
    SELECT SP.MaSP, SP.TenSP, SUM(CTHD.SoLuong) AS TongSoLuong
    FROM ChiTietHoaDon CTHD
    JOIN SanPham SP ON CTHD.MaSP = SP.MaSP
    GROUP BY SP.MaSP, SP.TenSP
    HAVING SUM(CTHD.SoLuong) >= @SoLuongMin;
    RETURN;
END;

SELECT * FROM dbo.fn_SanPhamBanChay(5);

--7️ Scalar Function - Kiểm tra khách hàng có tồn tại không
CREATE FUNCTION fn_KhachHangTonTai(@MaKH INT)
RETURNS BIT
AS
BEGIN
    DECLARE @TonTai BIT;
    IF EXISTS (SELECT 1 FROM KhachHang WHERE MaKH = @MaKH)
        SET @TonTai = 1;
    ELSE
        SET @TonTai = 0;
    RETURN @TonTai;
END;

SELECT dbo.fn_KhachHangTonTai(1) AS KhachHangTonTai;

--8 Inline Table-Valued Function - Lấy danh sách đơn hàng của nhà cung cấp
CREATE FUNCTION fn_DonHangNCC(@MaNCC INT)
RETURNS TABLE
AS
RETURN
(
    SELECT MaDH, NgayDat, TongTien
    FROM DatHang
    WHERE MaNCC = @MaNCC
);

SELECT * FROM dbo.fn_DonHangNCC(15);

--9️ Multi-Statement Table-Valued Function - Lịch sử giao hàng
CREATE FUNCTION fn_LichSuGiaoHang(@MaNCC INT)
RETURNS @LichSu TABLE (MaPGH INT, NgayGiao DATE, SoLuongGiao INT, ThanhTien DECIMAL(10,2))
AS
BEGIN
    INSERT INTO @LichSu
    SELECT PGH.MaPGH, PGH.NgayGiao, PGH.SoLuongGiao, PGH.ThanhTien
    FROM PhieuGiaoHang PGH
    JOIN DatHang DH ON PGH.MaDH = DH.MaDH
    WHERE DH.MaNCC = @MaNCC;
    RETURN;
END;

SELECT * FROM dbo.fn_LichSuGiaoHang(15);

--10 Scalar Function - Tính tổng doanh thu của cửa hàng
CREATE FUNCTION fn_TongDoanhThu()
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @DoanhThu DECIMAL(10,2);
    SELECT @DoanhThu = SUM(TongTien) FROM HoaDon;
    RETURN @DoanhThu;
END;

SELECT dbo.fn_TongDoanhThu() AS TongDoanhThu;



---Tạo 7- 10 trigger để kiểm soát dữ liệu
-- 1. Ngăn chặn xóa hóa đơn có chi tiết
CREATE TRIGGER trg_KhongXoaHoaDonCoChiTiet ON HoaDon
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ChiTietHoaDon WHERE MaHD IN (SELECT MaHD FROM deleted))
    BEGIN
        RAISERROR('Không thể xóa hóa đơn đã có chi tiết!', 16, 1);
        ROLLBACK;
    END
END;

DELETE FROM HoaDon WHERE MaHD = 22;

-- 2. Cập nhật tổng tiền hóa đơn khi thêm/sửa/xóa chi tiết
CREATE TRIGGER trg_CapNhatTongTienHoaDon ON ChiTietHoaDon
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE HoaDon
    SET TongTien = (SELECT SUM(ThanhTien) FROM ChiTietHoaDon WHERE ChiTietHoaDon.MaHD = HoaDon.MaHD)
    WHERE MaHD IN (SELECT DISTINCT MaHD FROM inserted UNION SELECT DISTINCT MaHD FROM deleted);
END;

UPDATE ChiTietHoaDon SET ThanhTien = 500000 WHERE MaHD = 22;
SELECT * FROM HoaDon WHERE MaHD = 22;

-- 3. Không cho phép số lượng sản phẩm âm
CREATE TRIGGER trg_KhongChoSoLuongAm
ON ChiTietHoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuong < 0)
    BEGIN
        RAISERROR('Số lượng sản phẩm không thể âm!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

UPDATE ChiTietHoaDon
SET SoLuong = -5, ThanhTien = 100000
WHERE MaHD = 22 AND MaSP = 21; 

-- 4. Kiểm tra khi cập nhật số lượng sản phẩm trong ChiTietHoaDon
CREATE TRIGGER trg_CheckSoLuongUpdate
ON ChiTietHoaDon
FOR UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted WHERE SoLuong < 1
    )
    BEGIN
        RAISERROR ('Số lượng sản phẩm phải lớn hơn hoặc bằng 1.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

UPDATE ChiTietHoaDon
SET SoLuong = 0
WHERE MaHD = 22 AND MaSP = 21;

-- 5. Trigger kiểm tra số lượng sản phẩm khi thêm vào hóa đơn
CREATE TRIGGER trg_Check_Quantity
ON ChiTietHoaDon
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuong <= 0)
    BEGIN
        RAISERROR (N'Số lượng sản phẩm phải lớn hơn 0.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

DELETE FROM ChiTietHoaDon WHERE MaHD = 22 AND MaSP = 21;

INSERT INTO ChiTietHoaDon (MaHD, MaSP, SoLuong, ThanhTien)
VALUES (22, 21, 0, 0.00); 

--6. Trigger tự động cập nhật tổng tiền hóa đơn
CREATE TRIGGER trg_Update_TotalAmount
ON ChiTietHoaDon
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE HoaDon
    SET TongTien = (
        SELECT SUM(ThanhTien) FROM ChiTietHoaDon WHERE ChiTietHoaDon.MaHD = HoaDon.MaHD
    )
    WHERE HoaDon.MaHD IN (SELECT MaHD FROM inserted UNION SELECT MaHD FROM deleted);
END;
GO

INSERT INTO ChiTietHoaDon (MaHD, MaSP, SoLuong, ThanhTien)
VALUES (22, 21, 2, 20.00);

SELECT * FROM HoaDon WHERE MaHD = 22;

--7. Trigger kiểm tra SoLuong nhập vào ChiTietHoaDon phải > 0
CREATE TRIGGER trg_Check_SoLuong_ChiTietHoaDon
ON ChiTietHoaDon
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE SoLuong <= 0)
    BEGIN
        RAISERROR(N'Số lượng phải lớn hơn 0!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO ChiTietHoaDon (MaHD, MaSP, SoLuong, ThanhTien)
VALUES (22, 31, -2, 30.00);
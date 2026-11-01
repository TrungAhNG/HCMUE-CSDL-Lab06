-- SQL Server 2022; chạy toàn bộ file bằng SSMS hoặc sqlcmd, tài khoản có quyền tạo CSDL.
-- File chỉ khởi tạo một CSDL mới; không xóa hay ghi đè dữ liệu đã tồn tại.
USE master;
GO
IF DB_ID(N'LabCSDL_SQL') IS NOT NULL THROW 50001, N'CSDL LabCSDL_SQL đã tồn tại. Dùng một instance mới để khởi tạo.', 1;
GO
CREATE DATABASE LabCSDL_SQL COLLATE Vietnamese_100_CI_AS;
GO
USE LabCSDL_SQL;
GO
SET XACT_ABORT ON;
BEGIN TRY
BEGIN TRANSACTION;
CREATE TABLE PHONGBAN(MaPB varchar(4) PRIMARY KEY, TenPB nvarchar(80) NOT NULL, MaTruongPhong varchar(4) NULL, NgayNhanChuc date NULL);
CREATE TABLE NHANVIEN(MaNV varchar(4) PRIMARY KEY, HoTen nvarchar(80) NOT NULL, NgaySinh date NOT NULL, GioiTinh nvarchar(3) NOT NULL CHECK(GioiTinh IN(N'Nam',N'Nữ')), Luong decimal(12,2) NOT NULL CHECK(Luong>=0), MaNQL varchar(4) NULL REFERENCES NHANVIEN(MaNV), MaPB varchar(4) NULL REFERENCES PHONGBAN(MaPB), CHECK(MaNQL<>MaNV));
ALTER TABLE PHONGBAN ADD FOREIGN KEY(MaTruongPhong) REFERENCES NHANVIEN(MaNV);
CREATE TABLE DIADIEM_PHONG(MaPB varchar(4) REFERENCES PHONGBAN(MaPB), DiaDiem nvarchar(80), PRIMARY KEY(MaPB,DiaDiem));
CREATE TABLE DUAN(MaDA varchar(4) PRIMARY KEY,TenDA nvarchar(100) NOT NULL,DiaDiem nvarchar(80) NOT NULL,MaPB varchar(4) NOT NULL REFERENCES PHONGBAN(MaPB),NgayBD date NOT NULL,NgayKT date NULL,KinhPhi decimal(15,2) NOT NULL CHECK(KinhPhi>=0),CHECK(NgayKT>=NgayBD));
CREATE TABLE CONGVIEC(MaDA varchar(4) REFERENCES DUAN(MaDA),STT int CHECK(STT>0),TenCV nvarchar(100) NOT NULL,PRIMARY KEY(MaDA,STT));
CREATE TABLE PHANCONG(MaNV varchar(4) REFERENCES NHANVIEN(MaNV),MaDA varchar(4),STT int,SoGio decimal(6,2) NOT NULL CHECK(SoGio>0),PRIMARY KEY(MaNV,MaDA,STT),FOREIGN KEY(MaDA,STT) REFERENCES CONGVIEC(MaDA,STT));
CREATE TABLE THANNHAN(MaNV varchar(4) REFERENCES NHANVIEN(MaNV),TenTN nvarchar(80),GioiTinh nvarchar(3) NOT NULL CHECK(GioiTinh IN(N'Nam',N'Nữ')),NgaySinh date NOT NULL,QuanHe nvarchar(20) NOT NULL CHECK(QuanHe IN(N'Con',N'Vợ',N'Chồng',N'Cha',N'Mẹ')),PRIMARY KEY(MaNV,TenTN));
INSERT INTO PHONGBAN VALUES
(N'PB01',N'Nghiên cứu',NULL,NULL),
(N'PB02',N'Kĩ thuật',NULL,NULL),
(N'PB03',N'Kinh doanh',NULL,NULL),
(N'PB04',N'Nhân sự',NULL,NULL),
(N'PB05',N'Đào tạo',NULL,NULL),
(N'PB06',N'Dự phòng',NULL,NULL);
INSERT INTO NHANVIEN VALUES
(N'NV01',N'Nguyễn Minh An',N'1979-02-15',N'Nữ',40000000,NULL,N'PB01'),
(N'NV02',N'Trần Thu Hà',N'1980-03-15',N'Nữ',35000000,N'NV01',N'PB02'),
(N'NV03',N'Lê Quốc Bình',N'1981-04-15',N'Nam',30000000,N'NV01',N'PB03'),
(N'NV04',N'Phạm Ngọc Lan',N'1982-05-15',N'Nữ',26000000,N'NV01',N'PB04'),
(N'NV05',N'Nguyễn Minh An',N'1983-06-15',N'Nữ',25000000,N'NV01',N'PB05'),
(N'NV06',N'Võ Thanh Nam',N'1984-07-15',N'Nam',28000000,N'NV01',N'PB01'),
(N'NV07',N'Đặng Mai Linh',N'1985-08-15',N'Nữ',22000000,N'NV01',N'PB01'),
(N'NV08',N'Bùi Anh Tuấn',N'1986-09-15',N'Nữ',18000000,N'NV06',N'PB01'),
(N'NV09',N'Đỗ Bảo Ngọc',N'1987-10-15',N'Nam',28000000,N'NV02',N'PB02'),
(N'NV10',N'Hồ Gia Huy',N'1988-11-15',N'Nữ',22000000,N'NV02',N'PB02'),
(N'NV11',N'Phan Kim Chi',N'1989-12-15',N'Nữ',15000000,N'NV09',N'PB02'),
(N'NV12',N'Lý Đức Long',N'1990-01-15',N'Nam',18000000,N'NV03',N'PB03'),
(N'NV13',N'Dương Thanh Vy',N'1991-02-15',N'Nữ',18000000,N'NV03',N'PB03'),
(N'NV14',N'Trịnh Hoàng Sơn',N'1992-03-15',N'Nữ',15000000,N'NV04',N'PB04'),
(N'NV15',N'Mai Thảo My',N'1993-04-15',N'Nam',12000000,N'NV05',N'PB05'),
(N'NV16',N'Ngô Minh Khang',N'1994-05-15',N'Nữ',28000000,N'NV01',N'PB01'),
(N'NV17',N'Cao Ngọc Anh',N'1995-06-15',N'Nữ',36000000,N'NV02',N'PB02'),
(N'NV18',N'Tạ Hoài Phương',N'1996-07-15',N'Nam',18000000,NULL,NULL);
INSERT INTO DIADIEM_PHONG VALUES
(N'PB01',N'TP.HCM'),
(N'PB01',N'Hà Nội'),
(N'PB02',N'TP.HCM'),
(N'PB02',N'Đà Nẵng'),
(N'PB03',N'Hà Nội'),
(N'PB04',N'TP.HCM'),
(N'PB05',N'Đà Nẵng');
INSERT INTO DUAN VALUES
(N'DA01',N'Cổng học tập',N'TP.HCM',N'PB01',N'2024-01-01',N'2024-12-31',500000000),
(N'DA02',N'Phân tích dữ liệu',N'Hà Nội',N'PB01',N'2025-01-01',NULL,800000000),
(N'DA03',N'Ứng dụng di động',N'TP.HCM',N'PB02',N'2025-06-15',NULL,500000000),
(N'DA04',N'Hạ tầng mạng',N'Đà Nẵng',N'PB02',N'2023-03-01',N'2024-06-30',300000000),
(N'DA05',N'Khảo sát thị trường',N'Hà Nội',N'PB03',N'2024-12-31',N'2025-05-01',200000000),
(N'DA06',N'Quản lí nhân sự',N'TP.HCM',N'PB04',N'2025-12-31',NULL,150000000),
(N'DA07',N'Lớp học số',N'Đà Nẵng',N'PB05',N'2026-01-01',NULL,200000000),
(N'DA08',N'Kho dữ liệu',N'TP.HCM',N'PB01',N'2026-02-01',NULL,1000000000),
(N'DA09',N'Trợ lí học tập',N'TP.HCM',N'PB02',N'2026-03-01',NULL,800000000),
(N'DA10',N'Học liệu mở',N'Hà Nội',N'PB05',N'2026-04-01',NULL,0);
INSERT INTO CONGVIEC VALUES
(N'DA01',1,N'Phân tích'),
(N'DA01',2,N'Triển khai'),
(N'DA01',3,N'Kiểm thử'),
(N'DA02',1,N'Phân tích'),
(N'DA02',2,N'Triển khai'),
(N'DA02',3,N'Kiểm thử'),
(N'DA03',1,N'Phân tích'),
(N'DA03',2,N'Triển khai'),
(N'DA03',3,N'Kiểm thử'),
(N'DA04',1,N'Phân tích'),
(N'DA04',2,N'Triển khai'),
(N'DA05',1,N'Phân tích'),
(N'DA05',2,N'Triển khai'),
(N'DA06',1,N'Phân tích'),
(N'DA06',2,N'Triển khai'),
(N'DA07',1,N'Phân tích'),
(N'DA07',2,N'Triển khai'),
(N'DA08',1,N'Phân tích'),
(N'DA08',2,N'Triển khai'),
(N'DA09',1,N'Phân tích'),
(N'DA09',2,N'Triển khai');
INSERT INTO PHANCONG VALUES
(N'NV01',N'DA01',1,8),
(N'NV01',N'DA02',1,8),
(N'NV01',N'DA08',1,4),
(N'NV02',N'DA03',1,10),
(N'NV02',N'DA04',1,10),
(N'NV02',N'DA09',1,5),
(N'NV03',N'DA05',1,12),
(N'NV04',N'DA06',1,15),
(N'NV05',N'DA07',1,10),
(N'NV06',N'DA01',1,10),
(N'NV06',N'DA01',2,10),
(N'NV06',N'DA02',1,10),
(N'NV06',N'DA08',1,10),
(N'NV07',N'DA01',2,15),
(N'NV07',N'DA02',2,15),
(N'NV08',N'DA01',3,20),
(N'NV09',N'DA03',1,10),
(N'NV09',N'DA03',2,10),
(N'NV09',N'DA04',1,10),
(N'NV09',N'DA09',1,10),
(N'NV10',N'DA03',2,15),
(N'NV10',N'DA04',2,10),
(N'NV11',N'DA03',3,20),
(N'NV12',N'DA05',1,20),
(N'NV12',N'DA01',1,5),
(N'NV13',N'DA05',2,15),
(N'NV15',N'DA07',2,20),
(N'NV16',N'DA01',1,8),
(N'NV16',N'DA01',2,8),
(N'NV16',N'DA01',3,8),
(N'NV16',N'DA02',1,8),
(N'NV16',N'DA08',1,8),
(N'NV18',N'DA02',3,10),
(N'NV18',N'DA03',1,10);
INSERT INTO THANNHAN VALUES
(N'NV01',N'Lê Thu Mai',N'Nữ',N'1982-02-10',N'Vợ'),
(N'NV01',N'Nguyễn Gia An',N'Nam',N'2010-01-01',N'Con'),
(N'NV02',N'Trần Bảo Hà',N'Nữ',N'2015-08-12',N'Con'),
(N'NV06',N'Võ Minh Anh',N'Nữ',N'2012-05-01',N'Con'),
(N'NV06',N'Võ Minh Khoa',N'Nam',N'2016-06-01',N'Con'),
(N'NV09',N'Đỗ Thanh Bình',N'Nam',N'1985-03-11',N'Chồng'),
(N'NV12',N'Bùi Lan',N'Nữ',N'1960-05-10',N'Mẹ'),
(N'NV15',N'Mai Thị Hoa',N'Nữ',N'1965-11-12',N'Mẹ');
UPDATE PHONGBAN SET MaTruongPhong='NV01',NgayNhanChuc='20200101' WHERE MaPB='PB01';
UPDATE PHONGBAN SET MaTruongPhong='NV02',NgayNhanChuc='20200101' WHERE MaPB='PB02';
UPDATE PHONGBAN SET MaTruongPhong='NV03',NgayNhanChuc='20200101' WHERE MaPB='PB03';
UPDATE PHONGBAN SET MaTruongPhong='NV04',NgayNhanChuc='20200101' WHERE MaPB='PB04';
UPDATE PHONGBAN SET MaTruongPhong='NV05',NgayNhanChuc='20200101' WHERE MaPB='PB05';
COMMIT;
END TRY
BEGIN CATCH
IF @@TRANCOUNT>0 ROLLBACK;
THROW;
END CATCH;
GO

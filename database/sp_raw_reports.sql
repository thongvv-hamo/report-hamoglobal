/*
 Navicat Premium Data Transfer

 Source Server         : HIS GANG PRODUCTION
 Source Server Type    : SQL Server
 Source Server Version : 14001000 (14.00.1000)
 Source Host           : 10.20.1.147:1433
 Source Catalog        : His.hamoglobal_production
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 14001000 (14.00.1000)
 File Encoding         : 65001

 Date: 08/12/2025 14:52:55
*/


-- ----------------------------
-- procedure structure for sp_raw_reports
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_raw_reports]') AND type IN ('P', 'PC', 'RF', 'X'))
	DROP PROCEDURE[dbo].[sp_raw_reports]
GO

CREATE PROCEDURE [dbo].[sp_raw_reports]
  @startDate AS DATE, 
  @endDate AS DATE, 
  @siteID AS INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET DATEFORMAT ymd;  -- đảm bảo hiểu đúng 'YYYY-MM-DD'

	IF OBJECT_ID('tempdb..#TmpDV_TongTienThanhToan') IS NOT NULL
			DROP TABLE #TmpDV_TongTienThanhToan;
	SELECT CAST
		(SUM(CTTT.ThanhTienThanhToan) AS DECIMAL (18, 0)) AS TienThanhToan,
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103) as NgayThanhToan,
		CTTT.IDHoSoDichVu as IDHoSoDichVuSanPhamThe
	INTO #TmpDV_TongTienThanhToan
	FROM
		HoSoKhachHangChiTietDichVu_ChiTietThanhToan CTTT
	WHERE
		CTTT.MaHTTT IN ('CK', 'TM', 'QT')
	GROUP BY
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103),
		CTTT.IDHoSoDichVu;
	-- -------------------	

	IF OBJECT_ID('tempdb..#TmpSP_TongTienThanhToan') IS NOT NULL
			DROP TABLE #TmpSP_TongTienThanhToan;
	SELECT CAST
		(SUM(CTTT.ThanhTienThanhToan) AS DECIMAL (18, 0)) AS TienThanhToan,
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103) as NgayThanhToan,
		CTTT.IDHoSoSanPham as IDHoSoDichVuSanPhamThe
	INTO #TmpSP_TongTienThanhToan
	FROM
		HoSoKhachHangChiTietSanPham_ChiTietThanhToan CTTT
	WHERE
		CTTT.MaHTTT IN ('CK', 'TM', 'QT')
	GROUP BY
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103),
		CTTT.IDHoSoSanPham;
	-- -------------------	

	IF OBJECT_ID('tempdb..#TmpGoi_TongTienThanhToan') IS NOT NULL
			DROP TABLE #TmpGoi_TongTienThanhToan;
	SELECT CAST
		(SUM(CTTT.ThanhTienThanhToan) AS DECIMAL (18, 0)) AS TienThanhToan,
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103) as NgayThanhToan,
		CTTT.IDHoSoComBoGoiDVSP as IDHoSoDichVuSanPhamThe
	INTO #TmpGoi_TongTienThanhToan
	FROM
		HoSoKhachHangComBoGoiDVSP_ChiTietThanhToan CTTT
	WHERE
		CTTT.MaHTTT IN ('CK', 'TM', 'QT')
	GROUP BY
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103),
		CTTT.IDHoSoComBoGoiDVSP;
	-- -------------------	

	IF OBJECT_ID('tempdb..#TmpTDV_TongTienThanhToan') IS NOT NULL
			DROP TABLE #TmpTDV_TongTienThanhToan;
	SELECT CAST
		(SUM(CTTT.ThanhTienThanhToan) AS DECIMAL (18, 0)) AS TienThanhToan,
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103) as NgayThanhToan,
		CTTT.IDHoSoTheDVTV as IDHoSoDichVuSanPhamThe
	INTO #TmpTDV_TongTienThanhToan
	FROM
		HoSoKhachHangChiTietTheDichVu_ChiTietThanhToan CTTT
	WHERE
		CTTT.MaHTTT IN ('CK', 'TM', 'QT')
	GROUP BY
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103),
		CTTT.IDHoSoTheDVTV;
		
	-- Đặt cọc
	IF OBJECT_ID('tempdb..#Tmp_datcoc') IS NOT NULL
	DROP TABLE #Tmp_datcoc;
	SELECT ID 
	INTO #Tmp_datcoc 
	FROM DmSanPham 
	WHERE MaSanPham LIKE '%DATCOC%';

	SELECT 
		T.[DateOfApplication],
		T.[SiteName],
		T.[Type],
		T.[Order],
		T.[CardNumber],
		T.[CustomerName],
		T.[GroupType],
		T.[RevenueType],
		T.[ProductGroup],
		T.[Code],
		T.[Description],
		T.[UnitPrice],
		T.[Quantity],
		T.[Total],
		T.[DiscountPercent],
		T.[DiscountAmount],
		T.[PaymentAmount],
		T.[DeductfromAccountCard],
		T.[ExceptionalPayment],
		T.[DeductfromDeposit],
		T.[CashBranches],
		T.[PaymentGBPBranches],
		T.[PaymentUSDBranches],
		T.[PaymentAUDBranches],
		T.[PaymentSGDBranches],
		T.[PaymentJPYBranches],
		T.[PaymentCADbranch],
		T.[BranchEURPayment],
		T.[TransferMegaHN],
		T.[TransferMegaHCM],
		T.[TransferBIDVMedproAsia],
		T.[TransferSacombankMedproAsia],
		T.[TransferVcbMedproAsia],
		T.[POSMegaHN],
		T.[POSMegaHCM],
		T.[POSBIDVMedproAsia],
		T.[POSSacombankMedproAsia],
		T.[POSVcbMedproAsia],
		T.[Debit],
		T.[Ktv],
		T.[Nursing],
		T.[RevenueConsultant],
		T.[Doctor],
		T.[Nurse],
		T.[Cashier],
		T.[CustomerServiceStaff],
		T.[CustomerType],
		T.[Note]
	 FROM

	(SELECT -- dịch vụ đã mua chưa sử dụng
		 CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103) AS 'DateOfApplication',
		 DMPB.TenPhongBan AS 'SiteName',
		CASE
			-- WHEN HS.MaHoSo LIKE '%_HH0%' THEN N'Hoàn huỷ'
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
					 THEN N'Thanh toán công nợ'
			ELSE N'Mua'
			END AS 'Type',
		CASE
	-- 		WHEN HS.MaHoSo LIKE '%_HH0%' THEN 'RF_' + HS.MaHoSo -- Đơn hoàn huỷ
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
					 THEN 'PAID_' + HS.MaHoSo
			ELSE HS.MaHoSo
		END AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		DMNDV.MaNhomDichVu AS 'GroupType',
		DMNDV.TenNhomDichVu AS 'RevenueType',
		DMNDV.TenNhomDichVu AS 'ProductGroup',
		DMDV.MaDichVu AS 'Code',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN N'Thanh toán đơn ' + HS.MaHoSo + N' - ' + CONVERT (VARCHAR(10), MIN(HSCN.NgayThanhToan), 103) + N' - ' + DMDV.TenDichVu
			ELSE DMDV.TenDichVu END AS 'Description',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTDV.DonGia END AS 'UnitPrice',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN 1
			ELSE CTDV.SoLuong END AS 'Quantity',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTDV.ThanhTien END AS 'Total',
		CTDV.GiamGia AS 'DiscountPercent',
		CTDV.ThanhTienGiamGia AS 'DiscountAmount',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTDV.TienThanhToan END AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' AND CTTT.ThanhTienThanhToan > 0 AND (TTCT.USD_sotien IS NULL OR TTCT.USD_sotien = 0 OR TTCT.USD_sotien = '') THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' AND CTTT.ThanhTienThanhToan > 0 AND TTCT.USD_sotien > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		ListTuVanVien.TenTuVanVien AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangChiTietDichVu CTDV ON CTDV.HoSoID=HS.IDHoSo
		INNER JOIN HoSoKhachHangChiTietDichVu_ChiTietThanhToan CTTT ON CTTT.IDHoSoDichVu = CTDV.IDHoSoDichVu
		LEFT JOIN HoSoKhachHangChiTietDichVu_ChiTietThanhToan HSCN ON CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 AND HSCN.IDHoSoDichVu = CTDV.IDHoSoDichVu AND HSCN.MaHTTT = 'CN' AND HSCN.ThanhTienThanhToan > 0
		LEFT JOIN PhieuThanhToanChiTiet TTCT ON TTCT.IDPhieuTTChiTiet = CTTT.IDPhieuTTChiTiet
		LEFT JOIN PhieuThanhToanChiTiet_NganHang TTNH ON TTNH.IDPhieuTTChiTiet = CTTT.IDPhieuTTChiTiet
		OUTER APPLY (
			SELECT
				STRING_AGG (NVX.DisplayName, ',') AS TenTuVanVien
			FROM
				(
					SELECT
						NV.IDNhanVien,
						NHOM.NhomNhanVien + ' ' + NV.TenNhanVien + N'(' +
						CASE
							WHEN MAX(CAST (HH.LoaiHoaHong AS INT)) = 1 THEN
								FORMAT (CAST (MAX(HH.HoaHong) * MAX(CTDV_TienThanhToan) / 100 AS DECIMAL (18, 0)), 'N0')
							WHEN MAX(CAST (HH.LoaiHoaHong AS INT)) = 0 THEN
								FORMAT (CAST (MAX(HH.HoaHong) * MAX(CTDV_TienThanhToan) / cb.TongTienThanhToan AS DECIMAL (18, 0)), 'N0')
							ELSE
								N'0'
						END + N')' AS DisplayName
					FROM
						HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
						INNER JOIN DmNhanVien NV ON HH.IDNhanVien = NV.IDNhanVien
						INNER JOIN DmNhomNhanVien NHOM ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
						CROSS APPLY (
							SELECT CAST
								(SUM(#TmpDV_TongTienThanhToan.TienThanhToan) AS DECIMAL (18, 0)) AS CTDV_TienThanhToan
							FROM
								#TmpDV_TongTienThanhToan
							WHERE
								#TmpDV_TongTienThanhToan.IDHoSoDichVuSanPhamThe = CTDV.IDHoSoDichVu
								AND #TmpDV_TongTienThanhToan.NgayThanhToan = CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103)
						) AS ca
						CROSS APPLY (SELECT CAST(CTDV.TienThanhToan AS DECIMAL(18,0)) AS TongTienThanhToan) AS cb
					WHERE
						HH.HoSoID = HS.IDHoSo
						AND HH.IDDichVuSanPhamThe = CTDV.IDDichVu
					GROUP BY
						NV.IDNhanVien,
						NHOM.NhomNhanVien,
						NV.TenNhanVien,
						CTDV_TienThanhToan,
						TongTienThanhToan
				) NVX
		) ListTuVanVien
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id=HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien=HS.IDNhanVienChamSoc
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = TTNH.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DmDichVu DMDV ON DMDV.IDDichVu = CTDV.IDDichVu
		LEFT JOIN DmNhomDichVu DMNDV ON DMNDV.IDNhomDichVu = DMDV.IDNhomDichVu
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		WHERE HS.MaHoSo NOT LIKE '%_HH0%'
			AND CTTT.NgayThanhToan >= @startDate
			AND CTTT.NgayThanhToan < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
		GROUP BY
			CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103),
			DMPB.TenPhongBan,
			HS.MaHoSo,
			DMKH.MaKHQuanLy,
			DMKH.HoTen,
			DMNDV.MaNhomDichVu,
			DMNDV.TenNhomDichVu,
			DMDV.MaDichVu,
			DMDV.TenDichVu,
			CTDV.DonGia,
			CTDV.SoLuong,
			CTDV.ThanhTien,
			CTDV.GiamGia,
			CTDV.ThanhTienGiamGia,
			CTDV.TienThanhToan,
			ListTuVanVien.TenTuVanVien,
			ThuNgan.Screenname,
			CSKH.TenNhanVien,
			HS.CuMoi,
			HS.GhiChu

	UNION ALL

	SELECT -- dịch vụ đã sử dụng
		CONVERT(VARCHAR(10), LTDT.NgayThucHien, 103) AS 'DateOfApplication',
		 DMPB.TenPhongBan AS 'SiteName',
		N'Sử dụng' AS 'Type',
		'DV_' + HS.MaHoSo AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		DMNDV.MaNhomDichVu AS 'GroupType',
		DMNDV.TenNhomDichVu AS 'RevenueType',
		DMNDV.TenNhomDichVu AS 'ProductGroup',
		DMDV.MaDichVu AS 'Code',
		DMDV.TenDichVu AS 'Description',
		LTDT.ThanhTien AS 'UnitPrice',
		1 AS 'Quantity',
		LTDT.ThanhTien AS 'Total',
		CTDV.GiamGia AS 'DiscountPercent',
		LTDT.ThanhTienGiamGia AS 'DiscountAmount',
		LTDT.ThanhTien - LTDT.ThanhTienGiamGia AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		'' AS 'DeductfromDeposit',
		'' AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		'' AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		'' AS 'TransferMegaHN',
		'' AS 'TransferMegaHCM',
		'' AS 'TransferBIDVMedproAsia',
		'' AS 'TransferSacombankMedproAsia',
		'' AS 'TransferVcbMedproAsia',
		'' AS 'POSMegaHN',
		'' AS 'POSMegaHCM',
		'' AS 'POSBIDVMedproAsia',
		'' AS 'POSSacombankMedproAsia',
		'' AS 'POSVcbMedproAsia',
		'' AS 'Debit',
		ListKtv.TenNhanVien AS 'Ktv',
		ListDieuDuong.TenNhanVien AS 'Nursing',
		ListTuVanVien.TenTuVanVien AS 'RevenueConsultant',
		ListBS.TenNhanVien AS 'Doctor',
		ListYTa.TenNhanVien AS 'Nurse',
		'' AS 'Cashier',
		'' AS 'Cashier',
		HS.CuMoi AS 'CustomerType',
		LTDT.GhiChu AS 'Note',
		'' AS SortKey 
	FROM
		HoSoKhachHang HS
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangChiTietDichVu CTDV ON CTDV.HoSoID=HS.IDHoSo
		INNER JOIN HoSoKhachHangLieuTrinhDieuTriDV LTDT ON LTDT.Id = CTDV.IDHoSoDichVu AND Type = 'DICH_VU' AND TrangThaiLieuTrinh = 2
		LEFT JOIN DmDichVu DMDV ON DMDV.IDDichVu = CTDV.IDDichVu
		LEFT JOIN DmNhomDichVu DMNDV ON DMNDV.IDNhomDichVu = DMDV.IDNhomDichVu
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 4 )
			LEFT JOIN DmNhomNhanVien NHOM ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
		) ListKtv
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 18 )
			LEFT JOIN DmNhomNhanVien NHOM ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
		) ListDieuDuong
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 17 )
		) ListBS
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 36 )
		) ListYTa
		OUTER APPLY (
			SELECT
				STRING_AGG (NVX.DisplayName, ',') AS TenTuVanVien
			FROM
			(
				SELECT
					NV.IDNhanVien,
					NHOM.NhomNhanVien + ' ' + NV.TenNhanVien + N'(' +
					CASE
						WHEN MAX(CAST (HH.LoaiHoaHong AS INT)) = 1 THEN
							FORMAT (CAST (MAX(HH.HoaHong) * MAX(CTDV_TienThanhToan) / CTDV.SoLuong / 100 AS DECIMAL(18, 2)), 'N2')
						WHEN MAX(CAST (HH.LoaiHoaHong AS INT)) = 0 THEN
							FORMAT (CAST (MAX(HH.HoaHong) * MAX(CTDV_TienThanhToan) / CTDV.SoLuong / cb.TongTienThanhToan AS DECIMAL(18, 2)), 'N2')
						ELSE
							N'0'
					END + N')' AS DisplayName
				FROM
					HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (
						SELECT CAST
							(SUM(#TmpDV_TongTienThanhToan.TienThanhToan) AS DECIMAL (18, 0)) AS CTDV_TienThanhToan
						FROM
							#TmpDV_TongTienThanhToan
						WHERE
							#TmpDV_TongTienThanhToan.IDHoSoDichVuSanPhamThe = CTDV.IDHoSoDichVu
					) AS ca
					CROSS APPLY (SELECT CAST(LTDT.ThanhTien - ISNULL(LTDT.ThanhTienGiamGia, 0) - ISNULL(LTDT.ThanhTienGiamGiaHD, 0) AS DECIMAL(18,0)) AS TongTienThanhToan) AS cb
				WHERE
					HH.HoSoID = HS.IDHoSo
					AND HH.IDDichVuSanPhamThe = CTDV.IDDichVu
				GROUP BY
					NV.IDNhanVien,
					NHOM.NhomNhanVien,
					NV.TenNhanVien,
					CTDV_TienThanhToan,
					TongTienThanhToan
			) NVX
	) ListTuVanVien
	WHERE LTDT.NgayThucHien >= @startDate
		AND LTDT.NgayThucHien < DATEADD(DAY, 1, @endDate)
		AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)

		UNION ALL
		
		SELECT -- Sản phẩm
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103) AS 'DateOfApplication',
		DMPB.TenPhongBan AS 'SiteName',
		CASE
			-- WHEN HS.MaHoSo LIKE '%_HH0%' THEN N'Hoàn huỷ'
			WHEN MAX(DCFlag) = 1 THEN N'Đặt cọc' -- Đơn đặt cọc
			WHEN (MAX(DCFlag) IS NULL OR MAX(DCFlag) = 0) AND SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 -- loại trừ đơn đặt cọc
					 THEN N'Thanh toán công nợ'
			ELSE N'Mua'
		END AS 'Type',
		CASE
	-- 		WHEN HS.MaHoSo LIKE '%_HH0%' THEN 'RF_' + HS.MaHoSo -- Đơn hoàn huỷ
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 AND MAX(DCFlag) = 1
					 THEN 'PCD_' + HS.MaHoSo -- Đơn đặt cọc
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 AND (MAX(DCFlag) IS NULL OR MAX(DCFlag) = 0)
					 THEN 'PAID_' + HS.MaHoSo
			ELSE HS.MaHoSo
		END AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		DMNSP.MaNhomSanPham AS 'GroupType',
		DMNSP.TenNhomSanPham AS 'RevenueType',
		DMNSP.TenNhomSanPham AS 'ProductGroup',
		DMSP.MaSanPham AS 'Code',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 AND (MAX(DCFlag) IS NULL OR MAX(DCFlag) = 0)
				THEN N'Thanh toán đơn ' + HS.MaHoSo + N' - ' + CONVERT (VARCHAR(10), MIN(HSCN.NgayThanhToan), 103) + N' - ' + DMSP.TenSanPham
			ELSE DMSP.TenSanPham END AS 'Description',
		CASE
			WHEN 
				(SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 AND (MAX(DCFlag) IS NULL OR MAX(DCFlag) = 0)) OR
				(SUM(CASE WHEN CTTT.ThanhTienThanhToan > 0 THEN 1 ELSE 0 END) > 0 AND MAX(DCFlag) = 1) 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTSP.DonGia END AS 'UnitPrice',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 AND (MAX(DCFlag) IS NULL OR MAX(DCFlag) = 0) 
				THEN 1
			ELSE CTSP.SoLuong END AS 'Quantity',
		CASE
			WHEN 
				(SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 AND (MAX(DCFlag) IS NULL OR MAX(DCFlag) = 0))  OR
				(SUM(CASE WHEN CTTT.ThanhTienThanhToan > 0 THEN 1 ELSE 0 END) > 0 AND MAX(DCFlag) = 1) 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTSP.ThanhTien END AS 'Total',
		CTSP.GiamGia AS 'DiscountPercent',
		CTSP.ThanhTienGiamGia AS 'DiscountAmount',
		CASE
			WHEN 
				(SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 AND (MAX(DCFlag) IS NULL OR MAX(DCFlag) = 0))  OR
				(SUM(CASE WHEN CTTT.ThanhTienThanhToan > 0 THEN 1 ELSE 0 END) > 0 AND MAX(DCFlag) = 1) 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTSP.TienThanhToan END AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' AND CTTT.ThanhTienThanhToan > 0 AND (TTCT.USD_sotien IS NULL OR TTCT.USD_sotien = 0 OR TTCT.USD_sotien = '') THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' AND CTTT.ThanhTienThanhToan > 0 AND TTCT.USD_sotien > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan > 0 AND (DC.DCFlag IS NULL OR DC.DCFlag <> 1)
		 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		MAX(ListTuVanVien.TenTuVanVien) AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangChiTietSanPham CTSP ON CTSP.HoSoID=HS.IDHoSo
		INNER JOIN HoSoKhachHangChiTietSanPham_ChiTietThanhToan CTTT ON CTTT.IDHoSoSanPham = CTSP.IDHoSoSanPham
		LEFT JOIN HoSoKhachHangChiTietSanPham_ChiTietThanhToan HSCN ON CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 AND HSCN.IDHoSoSanPham = CTSP.IDHoSoSanPham AND HSCN.MaHTTT = 'CN' AND HSCN.ThanhTienThanhToan > 0
		JOIN DmSanPham DMSP ON DMSP.ID = CTSP.SanPhamID
		JOIN DmNhomSanPham DMNSP ON DMNSP.ID = DMSP.NhomSanPhamID
		LEFT JOIN PhieuThanhToanChiTiet TTCT ON TTCT.IDPhieuTTChiTiet = CTTT.IDPhieuTTChiTiet
		LEFT JOIN PhieuThanhToanChiTiet_NganHang TTNH ON TTNH.IDPhieuTTChiTiet = CTTT.IDPhieuTTChiTiet 
		LEFT JOIN (
			SELECT ID, 1 AS DCFlag FROM #Tmp_datcoc
		) AS DC ON DC.ID = DMSP.ID  -- đánh dấu có phải là đặt cọc 
		OUTER APPLY (
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTSP_TienThanhToan / 100 AS DECIMAL(18,0)), 'N0')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTSP_TienThanhToan / cb.TongTienThanhToan AS DECIMAL(18,0)), 'N0')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (
							SELECT CAST
								(SUM(#TmpSP_TongTienThanhToan.TienThanhToan) AS DECIMAL (18, 0)) AS CTSP_TienThanhToan
							FROM
								#TmpSP_TongTienThanhToan
							WHERE
								#TmpSP_TongTienThanhToan.IDHoSoDichVuSanPhamThe = CTSP.IDHoSoSanPham
								AND #TmpSP_TongTienThanhToan.NgayThanhToan = CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103)
					) AS ca
					CROSS APPLY (SELECT CAST(CTSP.TienThanhToan AS DECIMAL(18,0)) AS TongTienThanhToan) AS cb
					WHERE HH.HoSoID = HS.IDHoSo 
							AND HH.IDDichVuSanPhamThe=CTSP.SanPhamID
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, CTSP_TienThanhToan, TongTienThanhToan
			) NVX
		) ListTuVanVien
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id = HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien = DMKH.IdChuyenVienTuVan
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = TTNH.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		WHERE HS.MaHoSo NOT LIKE '%_HH0%'
			AND CTTT.NgayThanhToan >= @startDate
			AND CTTT.NgayThanhToan < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
	GROUP BY
			CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103),
			DMPB.TenPhongBan,
			HS.MaHoSo,
			DMKH.MaKHQuanLy,
			DMKH.HoTen,
			DMNSP.MaNhomSanPham,
			DMNSP.TenNhomSanPham,
			DMSP.ID,
			DMSP.MaSanPham,
			DMSP.TenSanPham,
			CTSP.DonGia,
			CTSP.SoLuong,
			CTSP.ThanhTien,
			CTSP.GiamGia,
			CTSP.ThanhTienGiamGia,
			CTSP.TienThanhToan,
			ListTuVanVien.TenTuVanVien,
			ThuNgan.Screenname,
			CSKH.TenNhanVien,
			HS.CuMoi,
			HS.GhiChu
	HAVING NOT ( MAX(DCFlag) = 1 AND STRING_AGG(CTTT.MaHTTT, ',') IN ('TRUCOC,CN','CN,TRUCOC')) -- Loại bỏ đơn đặt cọc khấu trừ từ đơn gốc
		
		UNION ALL 
		
		SELECT -- Combo/gói dịch vụ sản phẩm đã mua chưa sử dụng
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103) AS 'DateOfApplication',
		 DMPB.TenPhongBan AS 'SiteName',
		CASE
			-- WHEN HS.MaHoSo LIKE '%_HH0%' THEN N'Hoàn huỷ'
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
					 THEN N'Thanh toán công nợ'
			ELSE N'Mua'
		END AS 'Type',
		CASE
	-- 		WHEN HS.MaHoSo LIKE '%_HH0%' THEN 'RF_' + HS.MaHoSo -- Đơn hoàn huỷ
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
					 THEN 'PAID_' + HS.MaHoSo
			ELSE HS.MaHoSo
		END AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		'' AS 'GroupType',
		DMGoi.TenComboGoiDVSP AS 'RevenueType',
		DMGoi.TenComboGoiDVSP AS 'ProductGroup',
		DMGoi.MaGoi AS 'Code',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN N'Thanh toán đơn ' + HS.MaHoSo + N' - ' + CONVERT (VARCHAR(10), MIN(HSCN.NgayThanhToan), 103) + N' - ' + DMGoi.TenComboGoiDVSP
			ELSE DMGoi.TenComboGoiDVSP END AS 'Description',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE DMGoi.GiaBan END AS 'UnitPrice',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN 1
			ELSE CTGoi.SoLuong END AS 'Quantity',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTGoi.ThanhTien END AS 'Total',
		CTGoi.GiamGia AS 'DiscountPercent',
		CTGoi.ThanhTienGiamGia AS 'DiscountAmount',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTGoi.TienThanhToan END AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS  'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' AND CTTT.ThanhTienThanhToan > 0 AND (TTCT.USD_sotien IS NULL OR TTCT.USD_sotien = 0 OR TTCT.USD_sotien = '') THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' AND CTTT.ThanhTienThanhToan > 0 AND TTCT.USD_sotien > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		MAX(ListTuVanVien.TenTuVanVien) AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangComBoGoiDVSP CTGoi ON CTGoi.HoSoID=HS.IDHoSo
		INNER JOIN HoSoKhachHangComBoGoiDVSP_ChiTietThanhToan CTTT ON CTTT.IDHoSoComBoGoiDVSP = CTGoi.IDHoSoComBoGoiDVSP
		LEFT JOIN HoSoKhachHangComBoGoiDVSP_ChiTietThanhToan HSCN ON CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 AND HSCN.IDHoSoComBoGoiDVSP = CTGoi.IDHoSoComBoGoiDVSP AND HSCN.MaHTTT = 'CN' AND HSCN.ThanhTienThanhToan > 0
		LEFT JOIN DmComboGoiDichVuSanPham DMGoi ON DMGoi.IDComboGoiDVSP = CTGoi.IDComboGoiDVSP
		LEFT JOIN PhieuThanhToanChiTiet TTCT ON TTCT.IDPhieuTTChiTiet = CTTT.IDPhieuTTChiTiet
		LEFT JOIN PhieuThanhToanChiTiet_NganHang TTNH ON TTNH.IDPhieuTTChiTiet = CTTT.IDPhieuTTChiTiet
		OUTER APPLY (
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTGoi_TienThanhToan / 100 AS DECIMAL(18,0)), 'N0')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTGoi_TienThanhToan / cb.TongTienThanhToan AS DECIMAL(18,0)), 'N0')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (
							SELECT CAST
								(SUM(#TmpGoi_TongTienThanhToan.TienThanhToan) AS DECIMAL (18, 0)) AS CTGoi_TienThanhToan
							FROM
								#TmpGoi_TongTienThanhToan
							WHERE
								#TmpGoi_TongTienThanhToan.IDHoSoDichVuSanPhamThe = CTGoi.IDHoSoComBoGoiDVSP
								AND #TmpGoi_TongTienThanhToan.NgayThanhToan = CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103)
					) AS ca
					CROSS APPLY (SELECT CAST(CTGoi.TienThanhToan AS DECIMAL(18,0)) AS TongTienThanhToan) AS cb
					WHERE HH.HoSoID = HS.IDHoSo 
							AND HH.IDDichVuSanPhamThe=CTGoi.IDComboGoiDVSP
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, CTGoi_TienThanhToan, TongTienThanhToan
			) NVX
		) ListTuVanVien
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id=HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien=HS.IDNhanVienChamSoc
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = TTNH.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		WHERE HS.MaHoSo NOT LIKE '%_HH0%'
			AND CTTT.NgayThanhToan >= @startDate
			AND CTTT.NgayThanhToan < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
	GROUP BY
		CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103),
		DMPB.TenPhongBan,
		HS.MaHoSo,
		DMKH.MaKHQuanLy,
		DMKH.HoTen,
		DMGoi.TenComboGoiDVSP,
		DMGoi.MaGoi,
		DMGoi.GiaBan,
		CTGoi.SoLuong,
		CTGoi.ThanhTien,
		CTGoi.GiamGia,
		CTGoi.ThanhTienGiamGia,
		CTGoi.TienThanhToan,
		ListTuVanVien.TenTuVanVien,
		ThuNgan.Screenname,
		CSKH.TenNhanVien,
		HS.CuMoi,
		HS.GhiChu

	UNION ALL 

	SELECT -- Combo/gói dịch vụ sản phẩm đã sử dụng
		CONVERT(VARCHAR(10), LTDT.NgayThucHien, 103) AS 'DateOfApplication',
		 DMPB.TenPhongBan AS 'SiteName',
		CASE 
			WHEN DMDV.TenDichVu LIKE 'BH%' THEN N'Bảo hành'	
			ELSE N'Sử dụng' 
		 END AS 'Type',
		'DV_' + HS.MaHoSo AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		'' AS 'GroupType',
		DMGoi.TenComboGoiDVSP AS 'RevenueType',
		DMGoi.TenComboGoiDVSP AS 'ProductGroup',
		DMDV.MaDichVu AS 'Code',
		DMDV.TenDichVu AS 'Description',
		DMDV.DonGia AS 'UnitPrice',
		1 AS 'Quantity',
		LTDT.ThanhTien AS 'Total',
		CTDV.GiamGia AS 'DiscountPercent',
		LTDT.ThanhTienGiamGia AS 'DiscountAmount',
		LTDT.ThanhTien - LTDT.ThanhTienGiamGia AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		'' AS 'DeductfromDeposit',
		'' AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		'' AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		'' AS 'TransferMegaHN',
		'' AS 'TransferMegaHCM',
		'' AS 'TransferBIDVMedproAsia',
		'' AS 'TransferSacombankMedproAsia',
		'' AS 'TransferVcbMedproAsia',
		'' AS 'POSMegaHN',
		'' AS 'POSMegaHCM',
		'' AS 'POSBIDVMedproAsia',
		'' AS 'POSSacombankMedproAsia',
		'' AS 'POSVcbMedproAsia',
		'' AS 'Debit',
		ListKtv.TenNhanVien AS 'Ktv',
		ListDieuDuong.TenNhanVien AS 'Nursing',
		ListTuVanVien.TenTuVanVien AS 'RevenueConsultant',
		ListBS.TenNhanVien AS 'Doctor',
		ListYTa.TenNhanVien AS 'Nurse',
		'' AS 'Cashier',
		'' AS 'Cashier',
		HS.CuMoi AS 'CustomerType',
		LTDT.GhiChu AS 'Note',
		'' AS SortKey 
	FROM
		HoSoKhachHang HS
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangComBoGoiDVSP CTGoi ON CTGoi.HoSoID=HS.IDHoSo
		INNER JOIN DmComboGoiDichVuSanPham DMGoi ON DMGoi.IDComboGoiDVSP = CTGoi.IDComboGoiDVSP
		INNER JOIN DmComboGoiDichVuSanPhamChiTiet DMGoiCT ON DMGoiCT.IDComboGoiDVSP = DMGoi.IDComboGoiDVSP AND DMGoiCT.Loai = 1 -- Dịch vụ
		INNER JOIN HoSoKhachHangLieuTrinhDieuTriDV LTDT ON LTDT.HoSoID=HS.IDHoSo AND LTDT.IDDichVu = DMGoiCT.IDDichVuSanPham AND Type = 'GOI' AND TrangThaiLieuTrinh = 2
		LEFT JOIN DmDichVu DMDV ON DMDV.IDDichVu = DMGoiCT.IDDichVuSanPham
		LEFT JOIN HoSoKhachHangChiTietDichVu CTDV ON CTDV.HoSoID=HS.IDHoSo AND CTDV.IDDichVu = DMDV.IDDichVu
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 4 )
			LEFT JOIN DmNhomNhanVien NHOM ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
		) ListKtv
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 18 )
			LEFT JOIN DmNhomNhanVien NHOM ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
		) ListDieuDuong
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 17 )
		) ListBS
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 36 )
		) ListYTa
		OUTER APPLY (
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * NULLIF(cb.TongTienThanhToan, 0) / 100 AS DECIMAL(18,2)), 'N2')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * NULLIF(cb.TongTienThanhToan, 0) / CTGoi_TienThanhToan AS DECIMAL(18,2)), 'N2')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (
							SELECT CAST
								(SUM(#TmpGoi_TongTienThanhToan.TienThanhToan) AS DECIMAL (18, 0)) AS CTGoi_TienThanhToan
							FROM
								#TmpGoi_TongTienThanhToan
							WHERE
								#TmpGoi_TongTienThanhToan.IDHoSoDichVuSanPhamThe = CTGoi.IDHoSoComBoGoiDVSP
					) AS ca
					CROSS APPLY (SELECT CAST(LTDT.ThanhTien - ISNULL(LTDT.ThanhTienGiamGia, 0) - ISNULL(LTDT.ThanhTienGiamGiaHD, 0) AS DECIMAL(18,0)) AS TongTienThanhToan) AS cb
					WHERE HH.HoSoID = HS.IDHoSo 
							AND HH.IDDichVuSanPhamThe=CTGoi.IDComboGoiDVSP
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, ca.CTGoi_TienThanhToan, TongTienThanhToan
			) NVX
		) ListTuVanVien
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
	WHERE LTDT.NgayThucHien >= @startDate
		AND LTDT.NgayThucHien < DATEADD(DAY, 1, @endDate)
		AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
		
		UNION ALL

		SELECT -- Thẻ dịch vụ
		 CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103) AS 'DateOfApplication',
		 DMPB.TenPhongBan AS 'SiteName',
		CASE
			-- WHEN HS.MaHoSo LIKE '%_HH0%' THEN N'Hoàn huỷ'
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
					 THEN N'Thanh toán công nợ'
			ELSE N'Mua'
		END AS 'Type',
		CASE
	-- 		WHEN HS.MaHoSo LIKE '%_HH0%' THEN 'RF_' + HS.MaHoSo -- Đơn hoàn huỷ
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
					 THEN 'PAID_' + HS.MaHoSo
			ELSE HS.MaHoSo
		END AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		'' AS 'GroupType',
		DMLT.TenLoaiTheDichVu AS 'RevenueType',
		DMLT.TenLoaiTheDichVu AS 'ProductGroup',
		DMTDV.MaTheDichVu AS 'Code',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN N'Thanh toán đơn ' + HS.MaHoSo + N' - ' + CONVERT (VARCHAR(10), MIN(HSCN.NgayThanhToan), 103) + N' - ' + DMTDV.TenTheDichVu
			ELSE DMTDV.TenTheDichVu END AS 'Description',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTTDV.DonGiaBan END AS 'UnitPrice',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN 1
			ELSE CTTDV.SoLuong END AS 'Quantity',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTTDV.ThanhTien END AS 'Total',
		CTTDV.GiamGia AS 'DiscountPercent',
		CTTDV.ThanhTienGiamGia AS 'DiscountAmount',
		CASE
			WHEN SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 THEN 1 ELSE 0 END) > 0 
				THEN SUM(CASE WHEN CTTT.MaHTTT IN ('TM', 'CK', 'QT') AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END)
			ELSE CTTDV.TienThanhToan END AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS  'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' AND CTTT.ThanhTienThanhToan > 0 AND (TTCT.USD_sotien IS NULL OR TTCT.USD_sotien = 0 OR TTCT.USD_sotien = '') THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' AND CTTT.ThanhTienThanhToan > 0 AND TTCT.USD_sotien > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan > 0 THEN CTTT.ThanhTienThanhToan ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		MAX(ListTuVanVien.TenTuVanVien) AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangChiTietTheDichVu CTTDV ON CTTDV.HoSoID=HS.IDHoSo
		INNER JOIN HoSoKhachHangChiTietTheDichVu_ChiTietThanhToan CTTT ON CTTT.IDHoSoTheDVTV = CTTDV.IDHoSoTheDVTV
		LEFT JOIN HoSoKhachHangChiTietTheDichVu_ChiTietThanhToan HSCN ON CTTT.MaHTTT = 'CN' AND CTTT.ThanhTienThanhToan < 0 AND HSCN.IDHoSoTheDVTV = CTTDV.IDHoSoTheDVTV AND HSCN.MaHTTT = 'CN' AND HSCN.ThanhTienThanhToan > 0
		LEFT JOIN PhieuThanhToanChiTiet TTCT ON TTCT.IDPhieuTTChiTiet = CTTT.IDPhieuTTChiTiet
		LEFT JOIN PhieuThanhToanChiTiet_NganHang TTNH ON TTNH.IDPhieuTTChiTiet = CTTT.IDPhieuTTChiTiet
		LEFT JOIN TheDichVu DMTDV ON DMTDV.IDTheDichVu = CTTDV.IDDichVuTheChiTiet
		LEFT JOIN DmLoaiTheDichVu DMLT ON DMLT.IDLoaiTheDichVu = DMTDV.IDLoaiTheDichVu
		OUTER APPLY (		
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
												THEN FORMAT(CAST(MAX(HH.HoaHong) * ca.CTTDV_TienThanhToan / 100 AS DECIMAL(18,0)), 'N0')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
												THEN FORMAT(CAST(MAX(HH.HoaHong) * ca.CTTDV_TienThanhToan / cb.TongTienThanhToan AS DECIMAL(18,0)), 'N0')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (
							SELECT CAST
								(SUM(#TmpTDV_TongTienThanhToan.TienThanhToan) AS DECIMAL (18, 0)) AS CTTDV_TienThanhToan
							FROM
								#TmpTDV_TongTienThanhToan
							WHERE
								#TmpTDV_TongTienThanhToan.IDHoSoDichVuSanPhamThe = CTTDV.IDHoSoTheDVTV
								AND #TmpTDV_TongTienThanhToan.NgayThanhToan = CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103)
					) AS ca
					CROSS APPLY (SELECT CAST(CTTDV.TienThanhToan AS DECIMAL(18,0)) AS TongTienThanhToan) AS cb
					WHERE HH.HoSoID = HS.IDHoSo 
							AND HH.IDDichVuSanPhamThe = DMTDV.IDTheDichVu
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, ca.CTTDV_TienThanhToan, TongTienThanhToan
			) NVX
		) ListTuVanVien
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id=HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien=HS.IDNhanVienChamSoc
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = TTNH.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		WHERE HS.MaHoSo NOT LIKE '%_HH0%'
			AND CTTT.NgayThanhToan >= @startDate
			AND CTTT.NgayThanhToan < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
	GROUP BY
			CONVERT(VARCHAR(10), CTTT.NgayThanhToan, 103),
			DMPB.TenPhongBan,
			HS.MaHoSo,
			DMKH.MaKHQuanLy,
			DMKH.HoTen,
			DMLT.TenLoaiTheDichVu,
			DMTDV.MaTheDichVu,
			DMTDV.TenTheDichVu,
			CTTDV.DonGiaBan,
			CTTDV.SoLuong,
			CTTDV.ThanhTien,
			CTTDV.GiamGia,
			CTTDV.ThanhTienGiamGia,
			CTTDV.TienThanhToan,
			ListTuVanVien.TenTuVanVien,
			ThuNgan.Screenname,
			CSKH.TenNhanVien,
			HS.CuMoi,
			HS.GhiChu
		
	UNION ALL

	SELECT -- Dịch vụ trong cấu hình thẻ đã sử dụng
		CONVERT(VARCHAR(10), LTDT.NgayThucHien, 103) AS 'DateOfApplication',
		 DMPB.TenPhongBan AS 'SiteName',
		CASE 
			WHEN DMDV.TenDichVu LIKE 'BH%' THEN N'Bảo hành'	
			ELSE N'Sử dụng' 
		 END AS 'Type',
		'DV_' + HS.MaHoSo AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		'' AS 'GroupType',
		DMLT.TenLoaiTheDichVu AS 'RevenueType',
		DMLT.TenLoaiTheDichVu AS 'ProductGroup',
		DMDV.MaDichVu AS 'Code',
		CHT.TenCauHinhThe AS 'Description',
		CHTKH.DonGia AS 'UnitPrice',
		1 AS 'Quantity',
		LTDT.ThanhTien AS 'Total',
		CHTKH.PhanTramGiamGia AS 'DiscountPercent',
		LTDT.ThanhTienGiamGia AS 'DiscountAmount',
		LTDT.ThanhTien - LTDT.ThanhTienGiamGia AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		'' AS 'DeductfromDeposit',
		'' AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		'' AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		'' AS 'TransferMegaHN',
		'' AS 'TransferMegaHCM',
		'' AS 'TransferBIDVMedproAsia',
		'' AS 'TransferSacombankMedproAsia',
		'' AS 'TransferVcbMedproAsia',
		'' AS 'POSMegaHN',
		'' AS 'POSMegaHCM',
		'' AS 'POSBIDVMedproAsia',
		'' AS 'POSSacombankMedproAsia',
		'' AS 'POSVcbMedproAsia',
		'' AS 'Debit',
		ListKtv.TenNhanVien AS 'Ktv',
		ListDieuDuong.TenNhanVien AS 'Nursing',
		ListTuVanVien.TenTuVanVien AS 'RevenueConsultant',
		ListBS.TenNhanVien AS 'Doctor',
		ListYTa.TenNhanVien AS 'Nurse',
		'' AS 'Cashier',
		'' AS 'Cashier',
		HS.CuMoi AS 'CustomerType',
		LTDT.GhiChu AS 'Note',
		'' AS SortKey 
	FROM
		HoSoKhachHang HS
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangChiTietTheDichVu CTTDV ON CTTDV.HoSoID=HS.IDHoSo
		INNER JOIN TheDichVu_CauHinhThe CHT ON CHT.IDTheDichVu = CTTDV.IDDichVuTheChiTiet
		INNER JOIN TheDichVu_CauHinhTheDichVuChitiet CHTCT ON CHTCT.IDCauHinhThe = CHT.ID
		INNER JOIN TheDichVu_CauHinhThe_KhachHang CHTKH ON CHTKH.IDHoSo = HS.IDHoSo AND CHTKH.IDCauHinhThe = CHTCT.IDCauHinhThe
		INNER JOIN DmDichVu DMDV ON DMDV.IDDichVu = CHTCT.IDDichVu
		INNER JOIN HoSoKhachHangLieuTrinhDieuTriDV LTDT ON LTDT.HoSoID=HS.IDHoSo AND LTDT.IDDichVu = CHTCT.IDDichVu AND LTDT.TrangThaiLieuTrinh = 2
		LEFT JOIN TheDichVu DMTDV ON DMTDV.IDTheDichVu = CTTDV.IDDichVuTheChiTiet
		LEFT JOIN DmLoaiTheDichVu DMLT ON DMLT.IDLoaiTheDichVu = DMTDV.IDLoaiTheDichVu
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 4 )
			LEFT JOIN DmNhomNhanVien NHOM ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
		) ListKtv
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 18 )
			LEFT JOIN DmNhomNhanVien NHOM ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
		) ListDieuDuong
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 17 )
		) ListBS
		OUTER APPLY (
			SELECT STRING_AGG(NV.TenNhanVien, ',') AS TenNhanVien
			FROM STRING_SPLIT(LTDT.ListIDNhanVien, ',') s
			LEFT JOIN DmNhanVien NV ON NV.IDNhanVien = TRY_CAST(s.value AS INT)
			AND NV.IDNhanVien IN ( SELECT IDNhanVien FROM DmNhanVien WHERE IDNhomNhanVien = 36 )
		) ListYTa
		OUTER APPLY (		
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
												THEN FORMAT(CAST(MAX(HH.HoaHong) * NULLIF(cb.TongTienThanhToan, 0) / 100 AS DECIMAL(18,2)), 'N2')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
												THEN FORMAT(CAST(MAX(HH.HoaHong) * NULLIF(cb.TongTienThanhToan, 0) / ca.CTTDV_TienThanhToan AS DECIMAL(18,2)), 'N2')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (
							SELECT CAST
								(SUM(#TmpTDV_TongTienThanhToan.TienThanhToan) AS DECIMAL (18, 0)) AS CTTDV_TienThanhToan
							FROM
								#TmpTDV_TongTienThanhToan
							WHERE
								#TmpTDV_TongTienThanhToan.IDHoSoDichVuSanPhamThe = CTTDV.IDHoSoTheDVTV
					) AS ca
					CROSS APPLY (SELECT CAST(LTDT.ThanhTien - ISNULL(LTDT.ThanhTienGiamGia, 0) - ISNULL(LTDT.ThanhTienGiamGiaHD, 0) AS DECIMAL(18,0)) AS TongTienThanhToan) AS cb
					WHERE HH.HoSoID = HS.IDHoSo 
							AND HH.IDDichVuSanPhamThe = DMTDV.IDTheDichVu
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, ca.CTTDV_TienThanhToan, TongTienThanhToan
			) NVX
		) ListTuVanVien
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
	WHERE LTDT.NgayThucHien >= @startDate
		AND LTDT.NgayThucHien < DATEADD(DAY, 1, @endDate)
		AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
		
	UNION ALL

	SELECT -- hồ sơ hoàn huỷ DỊCH VỤ
		CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103) AS 'DateOfApplication',
		DMPB.TenPhongBan AS 'SiteName',
		N'Hoàn huỷ' AS 'Type',
		'RF_' + HS.MaHoSo AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		DMNDV.MaNhomDichVu AS 'GroupType',
		DMNDV.TenNhomDichVu AS 'RevenueType',
		DMNDV.TenNhomDichVu AS 'ProductGroup',
		DMDV.MaDichVu AS 'Code',
		DMDV.TenDichVu AS 'Description',
		CTDV.DonGia AS 'UnitPrice',
		CTDV.SoLuong AS 'Quantity',
		CTDV.ThanhTien AS 'Total',
		'' AS 'DiscountPercent',
		'' AS 'DiscountAmount',
		CTDV.TienThanhToan AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' THEN CTDV.TienThanhToan ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' THEN CTDV.TienThanhToan ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		'' AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTDV.TienThanhToan ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTDV.TienThanhToan ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTDV.TienThanhToan ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTDV.TienThanhToan ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTDV.TienThanhToan ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTDV.TienThanhToan ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTDV.TienThanhToan ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTDV.TienThanhToan ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTDV.TienThanhToan ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTDV.TienThanhToan ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTDV.TienThanhToan > 0 THEN CTDV.TienThanhToan ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		MAX(ListTuVanVien.TenTuVanVien) AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN HoSoKhachHang HSGoc ON HSGoc.MaHoSo = LEFT(HS.MaHoSo, LEN(HS.MaHoSo) - CHARINDEX('_', REVERSE(HS.MaHoSo)))
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangChiTietDichVu CTDV ON CTDV.HoSoID=HS.IDHoSo
		INNER JOIN PhieuThuChi CTTT ON CTTT.HoSoID = HS.IDHoSo
		LEFT JOIN DmDichVu DMDV ON DMDV.IDDichVu = CTDV.IDDichVu
		LEFT JOIN DmNhomDichVu DMNDV ON DMNDV.IDNhomDichVu = DMDV.IDNhomDichVu
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id=HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien=HS.IDNhanVienChamSoc
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = CTTT.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		OUTER APPLY (
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTDV_TienThanhToan / 100 AS DECIMAL(18,0)), 'N0')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
													THEN FORMAT(CAST(MAX(HH.HoaHong) AS DECIMAL(18,0)), 'N0')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (SELECT CAST(CTDV.TienThanhToan AS DECIMAL(18,0)) AS CTDV_TienThanhToan) AS ca
					WHERE HH.HoSoID = HSGoc.IDHoSo 
							AND HH.IDDichVuSanPhamThe=CTDV.IDDichVu
							AND CTTT.MaHTTT IN ('TM', 'CK', 'QT')
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, CTDV_TienThanhToan
			) NVX
		) ListTuVanVien
		WHERE HS.MaHoSo LIKE '%_HH0%' 
			AND CTTT.LoaiThuChi = 2 
			AND CTTT.MaPhanLoaiThuChi = 'VH14'
			AND CTTT.NgayThuChi >= @startDate
			AND CTTT.NgayThuChi < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
		GROUP BY
			CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103),
			DMPB.TenPhongBan,
			HS.MaHoSo,
			DMKH.MaKHQuanLy,
			DMKH.HoTen,
			CTDV.SoLuong,
			CTDV.DonGia,
			CTDV.ThanhTien,
			CTDV.TienThanhToan,
			DMNDV.MaNhomDichVu,
			DMNDV.TenNhomDichVu,
			DMDV.MaDichVu,
			DMDV.TenDichVu,
			ListTuVanVien.TenTuVanVien,
			ThuNgan.Screenname,
			CSKH.TenNhanVien,
			HS.CuMoi,
			HS.GhiChu
			
	UNION ALL		

	SELECT -- hồ sơ hoàn huỷ SẢN PHẨM
		CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103) AS 'DateOfApplication',
		DMPB.TenPhongBan AS 'SiteName',
		N'Hoàn huỷ' AS 'Type',
		'RF_' + HS.MaHoSo AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		DMNSP.MaNhomSanPham AS 'GroupType',
		DMNSP.TenNhomSanPham AS 'RevenueType',
		DMNSP.TenNhomSanPham AS 'ProductGroup',
		DMSP.MaSanPham AS 'Code',
		DMSP.TenSanPham AS 'Description',
		CTSP.DonGia AS 'UnitPrice',
		CTSP.SoLuong AS 'Quantity',
		CTSP.ThanhTien AS 'Total',
		'' AS 'DiscountPercent',
		'' AS 'DiscountAmount',
		CTSP.TienThanhToan AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' THEN CTSP.TienThanhToan ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' THEN CTSP.TienThanhToan ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		'' AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTSP.TienThanhToan ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTSP.TienThanhToan ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTSP.TienThanhToan ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTSP.TienThanhToan ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTSP.TienThanhToan ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTSP.TienThanhToan ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTSP.TienThanhToan ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTSP.TienThanhToan ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTSP.TienThanhToan ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTSP.TienThanhToan ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTSP.TienThanhToan > 0 THEN CTSP.TienThanhToan ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		MAX(ListTuVanVien.TenTuVanVien) AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN HoSoKhachHang HSGoc ON HSGoc.MaHoSo = LEFT(HS.MaHoSo, LEN(HS.MaHoSo) - CHARINDEX('_', REVERSE(HS.MaHoSo)))
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangChiTietSanPham CTSP ON CTSP.HoSoID=HS.IDHoSo
		INNER JOIN PhieuThuChi CTTT ON CTTT.HoSoID = HS.IDHoSo
		LEFT JOIN DmSanPham DMSP ON DMSP.ID = CTSP.SanPhamID
		LEFT JOIN DmNhomSanPham DMNSP ON DMNSP.ID = DMSP.NhomSanPhamID
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id=HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien=HS.IDNhanVienChamSoc
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = CTTT.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		OUTER APPLY (
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTDV_TienThanhToan / 100 AS DECIMAL(18,0)), 'N0')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
													THEN FORMAT(CAST(MAX(HH.HoaHong) AS DECIMAL(18,0)), 'N0')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (SELECT CAST(CTSP.TienThanhToan AS DECIMAL(18,0)) AS CTDV_TienThanhToan) AS ca
					WHERE HH.HoSoID = HSGoc.IDHoSo 
							AND HH.IDDichVuSanPhamThe = CTSP.SanPhamID
							AND CTTT.MaHTTT IN ('TM', 'CK', 'QT')
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, CTDV_TienThanhToan
			) NVX
		) ListTuVanVien
		WHERE HS.MaHoSo LIKE '%_HH0%' 
			AND CTTT.LoaiThuChi = 2 
			AND CTTT.MaPhanLoaiThuChi = 'VH14'
			AND CTTT.NgayThuChi >= @startDate
			AND CTTT.NgayThuChi < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
		GROUP BY
			CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103),
			DMPB.TenPhongBan,
			HS.MaHoSo,
			DMKH.MaKHQuanLy,
			DMKH.HoTen,
			DMNSP.MaNhomSanPham,
			DMNSP.TenNhomSanPham,
			DMSP.MaSanPham,
			DMSP.TenSanPham,
			CTSP.DonGia,
			CTSP.SoLuong,
			CTSP.ThanhTien,
			CTSP.TienThanhToan,
			ListTuVanVien.TenTuVanVien,
			ThuNgan.Screenname,
			CSKH.TenNhanVien,
			HS.CuMoi,
			HS.GhiChu

	UNION ALL		

	SELECT -- hồ sơ hoàn huỷ GÓI
		CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103) AS 'DateOfApplication',
		DMPB.TenPhongBan AS 'SiteName',
		N'Hoàn huỷ' AS 'Type',
		'RF_' + HS.MaHoSo AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		'' AS 'GroupType',
		DMGoi.TenComboGoiDVSP AS 'RevenueType',
		DMGoi.TenComboGoiDVSP AS 'ProductGroup',
		DMGoi.MaGoi AS 'Code',
		DMGoi.TenComboGoiDVSP AS 'Description',
		CASE WHEN CTGoi.GiaBan > 0 THEN CTGoi.GiaBan ELSE CTGoi.DonGia END AS 'UnitPrice',
		CTGoi.SoLuong AS 'Quantity',
		CTGoi.ThanhTien AS 'Total',
		'' AS 'DiscountPercent',
		'' AS 'DiscountAmount',
		CTGoi.TienThanhToan AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' THEN CTGoi.TienThanhToan ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' THEN CTGoi.TienThanhToan ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		'' AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTGoi.TienThanhToan > 0 THEN CTGoi.TienThanhToan ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		MAX(ListTuVanVien.TenTuVanVien) AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN HoSoKhachHang HSGoc ON HSGoc.MaHoSo = LEFT(HS.MaHoSo, LEN(HS.MaHoSo) - CHARINDEX('_', REVERSE(HS.MaHoSo)))
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangComBoGoiDVSP CTGoi ON CTGoi.HoSoID=HS.IDHoSo
		INNER JOIN PhieuThuChi CTTT ON CTTT.HoSoID = HS.IDHoSo
		LEFT JOIN DmComboGoiDichVuSanPham DMGoi ON DMGoi.IDComboGoiDVSP = CTGoi.IDComboGoiDVSP
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id=HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien=HS.IDNhanVienChamSoc
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = CTTT.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		OUTER APPLY (
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTDV_TienThanhToan / 100 AS DECIMAL(18,0)), 'N0')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
													THEN FORMAT(CAST(MAX(HH.HoaHong) AS DECIMAL(18,0)), 'N0')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (SELECT CAST(CTGoi.TienThanhToan AS DECIMAL(18,0)) AS CTDV_TienThanhToan) AS ca
					WHERE HH.HoSoID = HSGoc.IDHoSo 
							AND HH.IDDichVuSanPhamThe = CTGoi.IDComboGoiDVSP
							AND CTTT.MaHTTT IN ('TM', 'CK', 'QT')
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, CTDV_TienThanhToan
			) NVX
		) ListTuVanVien
		WHERE HS.MaHoSo LIKE '%_HH0%' 
			AND CTTT.LoaiThuChi = 2 
			AND CTTT.MaPhanLoaiThuChi = 'VH14'
			AND CTTT.NgayThuChi >= @startDate
			AND CTTT.NgayThuChi < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
		GROUP BY
			CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103),
			DMPB.TenPhongBan,
			HS.MaHoSo,
			DMKH.MaKHQuanLy,
			DMKH.HoTen,
			DMGoi.TenComboGoiDVSP,
			DMGoi.MaGoi,
			CASE WHEN CTGoi.GiaBan > 0 THEN CTGoi.GiaBan ELSE CTGoi.DonGia END,
			CTGoi.SoLuong,
			CTGoi.ThanhTien,
			CTGoi.TienThanhToan,
			ListTuVanVien.TenTuVanVien,
			ThuNgan.Screenname,
			CSKH.TenNhanVien,
			HS.CuMoi,
			HS.GhiChu

	UNION ALL			

	SELECT -- hồ sơ hoàn huỷ THẺ
		CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103) AS 'DateOfApplication',
		DMPB.TenPhongBan AS 'SiteName',
		N'Hoàn huỷ' AS 'Type',
		'RF_' + HS.MaHoSo AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		'' AS 'GroupType',
		DMLT.TenLoaiTheDichVu AS 'RevenueType',
		DMLT.TenLoaiTheDichVu AS 'ProductGroup',
		DMTDV.MaTheDichVu AS 'Code',
		DMTDV.TenTheDichVu AS 'Description',
		CTTDV.DonGiaBan AS 'UnitPrice',
		CTTDV.SoLuong AS 'Quantity',
		CTTDV.ThanhTien AS 'Total',
		CTTDV.GiamGia AS 'DiscountPercent',
		CTTDV.ThanhTienGiamGia AS 'DiscountAmount',
		CTTDV.TienThanhToan AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' THEN CTTDV.TienThanhToan ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' THEN CTTDV.TienThanhToan ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		'' AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTDV.TienThanhToan > 0 THEN CTTDV.TienThanhToan ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		MAX(ListTuVanVien.TenTuVanVien) AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN HoSoKhachHang HSGoc ON HSGoc.MaHoSo = LEFT(HS.MaHoSo, LEN(HS.MaHoSo) - CHARINDEX('_', REVERSE(HS.MaHoSo)))
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN HoSoKhachHangChiTietTheDichVu CTTDV ON CTTDV.HoSoID=HS.IDHoSo
		INNER JOIN PhieuThuChi CTTT ON CTTT.HoSoID = HS.IDHoSo
		LEFT JOIN TheDichVu DMTDV ON DMTDV.IDTheDichVu = CTTDV.IDDichVuTheChiTiet
		LEFT JOIN DmLoaiTheDichVu DMLT ON DMLT.IDLoaiTheDichVu = DMTDV.IDLoaiTheDichVu
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id=HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien=HS.IDNhanVienChamSoc
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = CTTT.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		OUTER APPLY (
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTDV_TienThanhToan / 100 AS DECIMAL(18,0)), 'N0')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
													THEN FORMAT(CAST(MAX(HH.HoaHong) AS DECIMAL(18,0)), 'N0')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (SELECT CAST(CTTDV.TienThanhToan AS DECIMAL(18,0)) AS CTDV_TienThanhToan) AS ca
					WHERE HH.HoSoID = HSGoc.IDHoSo 
							AND HH.IDDichVuSanPhamThe = CTTDV.IDDichVuTheChiTiet
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, CTDV_TienThanhToan
			) NVX
		) ListTuVanVien
		WHERE HS.MaHoSo LIKE '%_HH0%' 
			AND CTTT.LoaiThuChi = 2 
			AND CTTT.MaPhanLoaiThuChi = 'VH14'
			AND CTTT.NgayThuChi >= @startDate
			AND CTTT.NgayThuChi < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
		GROUP BY
			CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103),
			DMPB.TenPhongBan,
			HS.MaHoSo,
			DMKH.MaKHQuanLy,
			DMKH.HoTen,
			DMLT.TenLoaiTheDichVu,
			DMTDV.MaTheDichVu,
			DMTDV.TenTheDichVu,
			CTTDV.DonGiaBan,
			CTTDV.SoLuong,
			CTTDV.ThanhTien,
			CTTDV.GiamGia,
			CTTDV.ThanhTienGiamGia,
			CTTDV.TienThanhToan,
			ListTuVanVien.TenTuVanVien,
			ThuNgan.Screenname,
			CSKH.TenNhanVien,
			HS.CuMoi,
			HS.GhiChu

	UNION ALL	
			
	SELECT -- phí hoàn huỷ
		CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103) AS 'DateOfApplication',
		DMPB.TenPhongBan AS 'SiteName',
		N'Hoàn huỷ' AS 'Type',
		'RF_' + HS.MaHoSo AS 'Order',
		DMKH.MaKHQuanLy AS 'CardNumber',
		DMKH.HoTen AS 'CustomerName',
		COALESCE(DMNSP.MaNhomSanPham, DMNDV.MaNhomDichVu) AS 'GroupType',
		N'Phí đổi dịch vụ'  AS 'RevenueType',
		N'Phí đổi dịch vụ'  AS 'ProductGroup',
		N'PDDV'  AS 'Code',
		N'Phí đổi dịch vụ'  AS 'Description',
		CTTT.SoTien AS 'UnitPrice',
		0 AS 'Quantity',
		CTTT.SoTien AS 'Total',
		'' AS 'DiscountPercent',
		'' AS 'DiscountAmount',
		CTTT.SoTien AS 'PaymentAmount',
		'' AS 'DeductfromAccountCard',
		'' AS 'ExceptionalPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'TRUCOC' THEN CTTT.SoTien ELSE 0 END) AS 'DeductfromDeposit',
		SUM(CASE WHEN CTTT.MaHTTT = 'TM' THEN CTTT.SoTien ELSE 0 END) AS 'CashBranches',
		'' AS 'PaymentGBPBranches',
		'' AS 'PaymentUSDBranches',
		'' AS 'PaymentAUDBranches',
		'' AS 'PaymentSGDBranches',
		'' AS 'PaymentJPYBranches',
		'' AS 'PaymentCADbranch',
		'' AS 'BranchEURPayment',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 111 THEN CTTT.SoTien ELSE 0 END) AS 'TransferMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 113 THEN CTTT.SoTien ELSE 0 END) AS 'TransferMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 114 THEN CTTT.SoTien ELSE 0 END) AS 'TransferBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 129 THEN CTTT.SoTien ELSE 0 END) AS 'TransferSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CK' AND DMNH.IDNganHang = 130 THEN CTTT.SoTien ELSE 0 END) AS 'TransferVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 111 THEN CTTT.SoTien ELSE 0 END) AS 'POSMegaHN',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 113 THEN CTTT.SoTien ELSE 0 END) AS 'POSMegaHCM',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 114 THEN CTTT.SoTien ELSE 0 END) AS 'POSBIDVMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 129 THEN CTTT.SoTien ELSE 0 END) AS 'POSSacombankMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'QT' AND DMNH.IDNganHang = 130 THEN CTTT.SoTien ELSE 0 END) AS 'POSVcbMedproAsia',
		SUM(CASE WHEN CTTT.MaHTTT = 'CN' AND CTTT.SoTien > 0 THEN CTTT.SoTien ELSE 0 END) AS 'Debit',
		'' AS 'Ktv',
		'' AS 'Nursing',
		MAX(ListTuVanVien.TenTuVanVien) AS 'RevenueConsultant',
		'' AS 'Doctor',
		'' AS 'Nurse',
		ThuNgan.Screenname AS 'Cashier',
		CSKH.TenNhanVien AS 'CustomerServiceStaff',
		HS.CuMoi AS 'CustomerType',
		HS.GhiChu AS 'Note',
		MIN(CTTT.MaHTTT) AS SortKey
	FROM
		HoSoKhachHang HS
		INNER JOIN HoSoKhachHang HSGoc ON HSGoc.IDHoSo = HS.IDHoSoGoc
		INNER JOIN DmKhachHang DMKH ON DMKH.MaKhachHang = HS.MaKhachHang
		INNER JOIN PhieuThuChi CTTT ON CTTT.HoSoID = HS.IDHoSo
		INNER JOIN HoanHuy ON HoanHuy.IDHoSo = HSGoc.IDHoSo AND HoanHuy.IDHoanHuy = CTTT.IDHoanHuy
		INNER JOIN HoanHuyChiTiet HHCT ON HHCT.IDHoanHuy = CTTT.IDHoanHuy
		LEFT JOIN DmSanPham DMSP ON DMSP.ID = HHCT.IDDichVuSanPhamThe AND HHCT.Loai = 'SAN_PHAM' 
		LEFT JOIN DmNhomSanPham DMNSP ON DMNSP.ID = DMSP.NhomSanPhamID
		LEFT JOIN DmDichVu DMDV ON DMDV.IDDichVu = HHCT.IDDichVuSanPhamThe AND HHCT.Loai = 'DICH_VU' 
		LEFT JOIN DmNhomDichVu DMNDV ON DMNDV.IDNhomDichVu = DMDV.IDNhomDichVu
		LEFT JOIN DmComboGoiDichVuSanPham DMGoi ON DMGoi.IDComboGoiDVSP = HHCT.IDDichVuSanPhamThe AND HHCT.Loai = 'GOI'
		LEFT JOIN TheDichVu DMTDV ON DMTDV.IDTheDichVu = HHCT.IDDichVuSanPhamThe AND HHCT.Loai = 'THE'
		LEFT JOIN DmLoaiTheDichVu DMLT ON DMLT.IDLoaiTheDichVu = DMTDV.IDLoaiTheDichVu
		LEFT JOIN PQ_User ThuNgan ON ThuNgan.Id=HS.NguoiDungID
		LEFT JOIN DmNhanVien CSKH ON CSKH.IDNhanVien=HS.IDNhanVienChamSoc
		LEFT JOIN DmNganHang DMNH ON DMNH.IDNganHang = CTTT.IDNganHang AND DMNH.IDNganHang IN (111, 113, 114, 129, 130)
		LEFT JOIN DMPhongBanOFChiNhanh DMPB ON DMPB.IDPhongBan = HS.IDPhongBan
		OUTER APPLY (
			SELECT 
					STRING_AGG(NVX.DisplayName, ',') AS TenTuVanVien
			FROM (
					SELECT 
							NV.IDNhanVien,
							NHOM.NhomNhanVien + ' ' + NV.TenNhanVien 
							+ N'(' + 
									CASE 
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 1 
													THEN FORMAT(CAST(MAX(HH.HoaHong) * CTDV_TienThanhToan / 100 AS DECIMAL(18,0)), 'N0')
											WHEN MAX(CAST(HH.LoaiHoaHong AS INT)) = 0 
													THEN FORMAT(CAST(MAX(HH.HoaHong) AS DECIMAL(18,0)), 'N0')
											ELSE N'0'
									END 
							+ N')' AS DisplayName
					FROM HoSoKhachHangChiTietDichVuSPThe_HoaHongNVTuVan HH
					INNER JOIN DmNhanVien NV 
							ON HH.IDNhanVien = NV.IDNhanVien
					INNER JOIN DmNhomNhanVien NHOM 
							ON NV.IDNhomNhanVien = NHOM.IDNhomNhanVien
					CROSS APPLY (SELECT CAST(CTTT.SoTien AS DECIMAL(18,0)) AS CTDV_TienThanhToan) AS ca
					WHERE HH.HoSoID = HSGoc.IDHoSo 
							AND HH.IDDichVuSanPhamThe=HHCT.IDDichVuSanPhamThe
							AND CTTT.MaHTTT IN ('TM', 'CK', 'QT')
					GROUP BY NV.IDNhanVien, NHOM.NhomNhanVien, NV.TenNhanVien, CTDV_TienThanhToan
			) NVX
		) ListTuVanVien
		WHERE HS.MaHoSo LIKE '%_HH0%' 
			AND CTTT.LoaiThuChi = 1 
			AND CTTT.MaPhanLoaiThuChi = 'VH14'
			AND CTTT.NgayThuChi >= @startDate
			AND CTTT.NgayThuChi < DATEADD(DAY, 1, @endDate)
			AND (@siteID IS NULL OR HS.IDPhongBan = @siteID)
		GROUP BY
			CONVERT(VARCHAR(10), CTTT.NgayThuChi, 103),
			DMPB.TenPhongBan,
			HS.MaHoSo,
			DMKH.MaKHQuanLy,
			DMKH.HoTen,
			CTTT.SoTien,
			COALESCE(DMNSP.MaNhomSanPham, DMNDV.MaNhomDichVu),
			ListTuVanVien.TenTuVanVien,
			ThuNgan.Screenname,
			CSKH.TenNhanVien,
			HS.CuMoi,
			HS.GhiChu
	
) AS T
-- WHERE 
-- 	(@siteID IS NULL OR T.[SiteName] = @siteID)
	ORDER BY T.[DateOfApplication],T.[Type],T.[Order],T.SortKey DESC
	
END;
GO


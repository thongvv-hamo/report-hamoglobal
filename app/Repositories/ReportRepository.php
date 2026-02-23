<?php

namespace App\Repositories;

use Illuminate\Support\Facades\DB;

class ReportRepository
{
    /**
     * Lấy danh sách báo cáo theo bộ lọc.
     *
     * @param string $startDate
     * @param string $endDate
     * @param int|null $siteID
     * @return array
     */
    public function getReports($startDate, $endDate, $siteID = null)
    {
        // Giả sử bạn dùng SQL Server
        $query = "EXEC dbo.sp_raw_reports ?, ?, ?";
        if (is_array($siteID)) {
            $data = [];
            foreach ($siteID as $value) {
                $data = array_merge($data, DB::connection('sqlsrv')->select($query, [$startDate, $endDate, $value]));
            }
            return $data;
        }

        return DB::connection('sqlsrv')->select($query, [$startDate, $endDate, $siteID]);
    }

    /**
     * Lấy danh sách phòng ban
     *
     * @return array
     */
    public function getSites()
    {
        // Giả sử bạn dùng SQL Server
        $query = "SELECT IDPhongBan, TenPhongBan FROM DMPhongBanOFChiNhanh WHERE TrangThaiSuDung = ?";

        return DB::connection('sqlsrv')->select($query, [1]);
    }
}

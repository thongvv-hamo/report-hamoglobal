<?php

namespace App\Services;

use App\Repositories\ReportRepository;
use Carbon\Carbon;

class ReportService
{
    protected $reportRepository;

    public function __construct(ReportRepository $reportRepository)
    {
        $this->reportRepository = $reportRepository;
    }

    /**
     * Xử lý và trả về dữ liệu báo cáo.
     */
    public function getReports($startDate, $endDate, $siteID = null)
    {
        // Chuẩn hóa định dạng ngày
        $startDate = Carbon::parse($startDate)->format('Y-m-d');
        $endDate = Carbon::parse($endDate)->format('Y-m-d');

        return $this->reportRepository->getReports($startDate, $endDate, $siteID);
    }

    /**
     * Lấy danh sách phòng ban
     *
     * @return array
     */
    public function getSites()
    {
        return $this->reportRepository->getSites();
    }
    
}

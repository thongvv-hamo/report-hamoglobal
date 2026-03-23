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
     * @param string|null $type
     * @return array
     */
    public function getReports($startDate, $endDate, $siteID = null, $type = null)
    {
        // $query = "EXEC dbo.sp_raw_reports ?, ?, ?";
        // if (is_array($siteID)) {
        //     $data = [];
        //     foreach ($siteID as $value) {
        //         $data = array_merge($data, DB::connection('sqlsrv')->select($query, [$startDate, $endDate, $value]));
        //     }
        //     return $data;
        // }

        // return DB::connection('sqlsrv')->select($query, [$startDate, $endDate, $siteID]);
        $connection = $type == 'test' ? 'sqlsrv_test' : 'sqlsrv';
        return DB::connection($connection)
            ->table('view_raw_reports')
            ->selectRaw("
                CAST(DateOfApplication AS datetime) as DateOfApplication, 
                SiteName,
                Type,
                [Order],
                CardNumber,
                CustomerName,
                GroupType,
                RevenueType,
                ProductGroup,
                Code,
                Description,
                UnitPrice,
                Quantity,
                Total,
                DiscountPercent,
                DiscountAmount,
                PaymentAmount,
                DeductfromAccountCard,
                ExceptionalPayment,
                DeductfromEmployeeSalary,
                DeductfromDeposit,
                CashBranches,
                PaymentGBPBranches,
                PaymentUSDBranches,
                PaymentAUDBranches,
                PaymentSGDBranches,
                PaymentJPYBranches,
                PaymentCADbranch,
                BranchEURPayment,
                TransferMegaHN,
                TransferMegaHCM,
                TransferBIDVMedproAsia,
                TransferSacombankMedproAsia,
                TransferVcbMedproAsia,
                POSMegaHN,
                POSMegaHCM,
                POSBIDVMedproAsia,
                POSSacombankMedproAsia,
                POSVcbMedproAsia,
                Debit,
                Ktv,
                Nursing,
                RevenueConsultant,
                Doctor,
                Nurse,
                Cashier,
                CustomerServiceStaff,
                CustomerType,
                Note")
            ->whereBetween('DateOfApplication', [$startDate, $endDate])
            ->when($siteID, function ($q, $siteID) {
                if (is_array($siteID)) {
                    $q->whereIn('site_id', $siteID);
                } else {
                    $q->where('site_id', $siteID);
                }
            })
            ->orderBy('DateOfApplication')
            ->orderBy('Type')
            ->orderBy('Order')
            ->orderByDesc('SortKey')
            ->orderBy('SortPriority')
            ->get()
            ->toArray();
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

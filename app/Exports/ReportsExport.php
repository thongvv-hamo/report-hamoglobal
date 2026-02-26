<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithMapping;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use Carbon\Carbon;

class ReportsExport implements FromQuery, WithHeadings, WithChunkReading, WithColumnFormatting, WithMapping
{
    protected $startDate;
    protected $endDate;
    protected $siteID;

    public function __construct($startDate, $endDate, $siteID)
    {
        $this->startDate = $startDate;
        $this->endDate = $endDate;
        $this->siteID = $siteID;
    }

    public function query()
    {
        return DB::connection('sqlsrv')
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
            ->whereBetween('DateOfApplication', [$this->startDate, $this->endDate])
            ->when($this->siteID, function ($q) {
                if (is_array($this->siteID)) {
                    $q->whereIn('site_id', $this->siteID);
                } else {
                    $q->where('site_id', $this->siteID);
                }
            })
            ->orderBy('DateOfApplication')
            ->orderBy('Type')
            ->orderBy('Order')
            ->orderByDesc('SortKey');
    }

    public function chunkSize(): int
    {
        return 1000;
    }

    public function columnFormats(): array
    {
        return [
            'A' => NumberFormat::FORMAT_DATE_DDMMYYYY,
        ];
    }

    public function map($row): array
    {
        return [
            // 👇 convert sang Excel serial date
            Date::dateTimeToExcel(
                Carbon::parse($row->DateOfApplication)
            ),

            $row->SiteName,
            $row->Type,
            $row->Order,
            $row->CardNumber,
            $row->CustomerName,
            $row->GroupType,
            $row->RevenueType,
            $row->ProductGroup,
            $row->Code,
            $row->Description,
            $row->UnitPrice,
            $row->Quantity,
            $row->Total,
            $row->DiscountPercent,
            $row->DiscountAmount,
            $row->PaymentAmount,
            $row->DeductfromAccountCard,
            $row->ExceptionalPayment,
            $row->DeductfromDeposit,
            $row->CashBranches,
            $row->PaymentGBPBranches,
            $row->PaymentUSDBranches,
            $row->PaymentAUDBranches,
            $row->PaymentSGDBranches,
            $row->PaymentJPYBranches,
            $row->PaymentCADbranch,
            $row->BranchEURPayment,
            $row->TransferMegaHN,
            $row->TransferMegaHCM,
            $row->TransferBIDVMedproAsia,
            $row->TransferSacombankMedproAsia,
            $row->TransferVcbMedproAsia,
            $row->POSMegaHN,
            $row->POSMegaHCM,
            $row->POSBIDVMedproAsia,
            $row->POSSacombankMedproAsia,
            $row->POSVcbMedproAsia,
            $row->Debit,
            $row->Ktv,
            $row->Nursing,
            $row->RevenueConsultant,
            $row->Doctor,
            $row->Nurse,
            $row->Cashier,
            $row->CustomerServiceStaff,
            $row->CustomerType,
            $row->Note,
        ];
    }

    public function headings(): array
    {
        return [
            'Ngày tháng',
            'Cơ sở',
            'Loại',
            'Order',
            'Số thẻ',
            'Tên khách hàng',
            'Loại nhóm',
            'Loại doanh thu',
            'Nhóm sản phẩm',
            'Mã',
            'Diễn giải',
            'Đơn giá',
            'Số lượng',
            'Thành tiền',
            'Chiết khấu (%)',
            'Chiết khấu (số tiền)',
            'Số tiền thanh toán',
            'Trừ thẻ TK',
            'Thanh toán ngoại lệ',
            'Cấn trừ đặt cọc',
            'TM các chi nhánh',
            'Thanh toán GBP các chi nhánh',
            'Thanh toán USD các chi nhánh',
            'Thanh toán AUD chi nhánh',
            'Thanh toán SGD chi nhánh',
            'Thanh toán JPY chi nhánh',
            'Thanh toán CAD chi nhánh',
            'Thanh toán EUR chi nhánh',
            'CK CT MEGA - CN HN',
            'CK CT MEGA - CN HCM',
            'CK BIDV - CT MEDPRO ASIA',
            'CK Sacombank - CT MEDPRO ASIA',
            'CK VCB - CT MEDPRO ASIA',
            'POS CT MEGA - CN HN',
            'POS CT MEGA - CN HCM',
            'POS BIDV - CT MEDPRO ASIA',
            'POS Sacombank - CT MEDPRO ASIA',
            'POS VCB - CT MEDPRO ASIA',
            'Ghi nợ',
            'KTV',
            'Điều dưỡng',
            'TVDT (Tư vấn doanh thu)',
            'Bác sĩ',
            'Y tá',
            'Thu ngân',
            'CSKH',
            'Loại khách hàng',
            'Ghi chú'
        ];
    }
}

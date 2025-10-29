<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ReportsExport implements FromCollection, WithHeadings
{
    protected $data;

    public function __construct($data)
    {
        $this->data = collect($data);
    }

    public function collection()
    {
        return $this->data;
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

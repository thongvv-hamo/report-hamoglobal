
<form method="GET" action="{{ route('reports.index') }}" class="mb-4 flex gap-4 items-end">
    <div>
        <label for="start_date" class="block text-sm font-medium">Từ ngày</label>
        <input type="date" id="start_date" name="start_date" value="{{ request('start_date') }}" class="form-input">
    </div>

    <div>
        <label for="end_date" class="block text-sm font-medium">Đến ngày</label>
        <input type="date" id="end_date" name="end_date" value="{{ request('end_date') }}" class="form-input">
    </div>

    <div>
        <label for="branch_id" class="block text-sm font-medium">Cơ sở</label>
        <select id="branch_id" name="branch_id" class="form-select">
            <option value="">Tất cả</option>
            <option value="1" @selected(request('branch_id') == 1)>Cơ sở 1</option>
            <option value="2" @selected(request('branch_id') == 2)>Cơ sở 2</option>
        </select>
    </div>

    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Lọc</button>
</form>

<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Danh sách báo cáo') }}
        </h2>
    </x-slot>

    <div class="py-6">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6">
                <table class="min-w-full border border-gray-200">
                    <thead>
                        <tr class="bg-gray-100">
                            <th class="px-4 py-2 border">#</th>
                            <th class="px-4 py-2 border">Ngày tháng</th>
                            <th class="px-4 py-2 border">Cơ sở</th>
                            <th class="px-4 py-2 border">Loại</th>
                            <th class="px-4 py-2 border">Order</th>
                            <th class="px-4 py-2 border">Số thẻ</th>
                            <th class="px-4 py-2 border">Tên khách hàng</th>
                            <th class="px-4 py-2 border">Loại nhóm</th>
                            <th class="px-4 py-2 border">Loại doanh thu</th>
                            <th class="px-4 py-2 border">Nhóm sản phẩm</th>
                            <th class="px-4 py-2 border">Mã</th>
                            <th class="px-4 py-2 border">Diễn giải</th>
                            <th class="px-4 py-2 border">Đơn giá</th>
                            <th class="px-4 py-2 border">Số lượng</th>
                            <th class="px-4 py-2 border">Thành tiền</th>
                            <th class="px-4 py-2 border">Chiết khấu(%)</th>
                            <th class="px-4 py-2 border">Chiết khấu(số tiền)</th>
                            <th class="px-4 py-2 border">Số tiền thanh toán</th>
                            <th class="px-4 py-2 border">Trừ thẻ TK</th>
                            <th class="px-4 py-2 border">Thanh toán ngoại lệ</th>
                            <th class="px-4 py-2 border">Cấn trừ đặt cọc</th>
                            <th class="px-4 py-2 border">TM các chi nhánh</th>
                            <th class="px-4 py-2 border">Thanh toán GBP các chi nhánh</th>
                            <th class="px-4 py-2 border">Thanh toán USD các chi nhánh</th>
                            <th class="px-4 py-2 border">Thanh toán AUD(Úc) chi nhánh</th>
                            <th class="px-4 py-2 border">Thanh toán SGD(Singapore) chi nhánh</th>
                            <th class="px-4 py-2 border">Thanh toán JPY(Nhật) chi nhánh</th>
                            <th class="px-4 py-2 border">Thanh toán CAD(Canada) chi nhánh</th>
                            <th class="px-4 py-2 border">Thanh toán EUR chi nhánh</th>
                            <th class="px-4 py-2 border">CK CT MEGA - CN HN</th>
                            <th class="px-4 py-2 border">CK CT MEGA - CN HCM</th>
                            <th class="px-4 py-2 border">CK BIDV - CT MEDPRO ASIA</th>
                            <th class="px-4 py-2 border">CK Sacombank - CT MEDPRO ASIA</th>
                            <th class="px-4 py-2 border">CK VCB - CT MEDPRO ASIA</th>
                            <th class="px-4 py-2 border">POS CT MEGA - CN HN</th>
                            <th class="px-4 py-2 border">POS CT MEGA - CN HCM</th>
                            <th class="px-4 py-2 border">POS BIDV - CT MEDPRO ASIA</th>
                            <th class="px-4 py-2 border">POS Sacombank - CT MEDPRO ASIA</th>
                            <th class="px-4 py-2 border">POS VCB - CT MEDPRO ASIA</th>
                            <th class="px-4 py-2 border">Ghi nợ</th>
                            <th class="px-4 py-2 border">KTV</th>
                            <th class="px-4 py-2 border">Điều dưỡng</th>
                            <th class="px-4 py-2 border">TVDT (Tư vấn doanh thu)</th>
                            <th class="px-4 py-2 border">Bác Sĩ</th>
                            <th class="px-4 py-2 border">Y tá</th>
                            <th class="px-4 py-2 border">Thu Ngân</th>
                            <th class="px-4 py-2 border">CSKH</th>
                            <th class="px-4 py-2 border">Loại khách hàng</th>
                            <th class="px-4 py-2 border">Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        @php $stt = 1; @endphp
                        @foreach ($reports as $report)
                            <tr>
                                <td class="border px-4 py-2">{{ $stt }}</td>
                                <td class="border px-4 py-2">{{ $report->DateOfApplication }}</td>
                                <td class="border px-4 py-2">{{ $report->SiteName }}</td>
                                <td class="border px-4 py-2">{{ $report->Type }}</td>
                                <td class="border px-4 py-2">{{ $report->Order }}</td>
                                <td class="border px-4 py-2">{{ $report->CardNumber }}</td>
                                <td class="border px-4 py-2">{{ $report->CustomerName }}</td>
                                <td class="border px-4 py-2">{{ $report->GroupType }}</td>
                                <td class="border px-4 py-2">{{ $report->RevenueType }}</td>
                                <td class="border px-4 py-2">{{ $report->ProductGroup }}</td>
                                <td class="border px-4 py-2">{{ $report->Code }}</td>
                                <td class="border px-4 py-2">{{ $report->Description }}</td>
                                <td class="border px-4 py-2">{{ $report->UnitPrice }}</td>
                                <td class="border px-4 py-2">{{ $report->Quantity }}</td>
                                <td class="border px-4 py-2">{{ $report->Total }}</td>
                                <td class="border px-4 py-2">{{ $report->DiscountPercent }}</td>
                                <td class="border px-4 py-2">{{ $report->DiscountAmount }}</td>
                                <td class="border px-4 py-2">{{ $report->PaymentAmount }}</td>
                                <td class="border px-4 py-2">{{ $report->DeductfromAccountCard }}</td>
                                <td class="border px-4 py-2">{{ $report->ExceptionalPayment }}</td>
                                <td class="border px-4 py-2">{{ $report->DeductfromDeposit }}</td>
                                <td class="border px-4 py-2">{{ $report->CashBranches }}</td>
                                <td class="border px-4 py-2">{{ $report->PaymentGBPBranches }}</td>
                                <td class="border px-4 py-2">{{ $report->PaymentUSDBranches }}</td>
                                <td class="border px-4 py-2">{{ $report->PaymentAUDBranches }}</td>
                                <td class="border px-4 py-2">{{ $report->PaymentSGDBranches }}</td>
                                <td class="border px-4 py-2">{{ $report->PaymentJPYBranches }}</td>
                                <td class="border px-4 py-2">{{ $report->PaymentCADbranch }}</td>
                                <td class="border px-4 py-2">{{ $report->BranchEURPayment }}</td>
                                <td class="border px-4 py-2">{{ $report->TransferMegaHN }}</td>
                                <td class="border px-4 py-2">{{ $report->TransferMegaHCM }}</td>
                                <td class="border px-4 py-2">{{ $report->TransferBIDVMedproAsia }}</td>
                                <td class="border px-4 py-2">{{ $report->TransferSacombankMedproAsia }}</td>
                                <td class="border px-4 py-2">{{ $report->TransferVcbMedproAsia }}</td>
                                <td class="border px-4 py-2">{{ $report->POSMegaHN }}</td>
                                <td class="border px-4 py-2">{{ $report->POSMegaHCM }}</td>
                                <td class="border px-4 py-2">{{ $report->POSBIDVMedproAsia }}</td>
                                <td class="border px-4 py-2">{{ $report->POSSacombankMedproAsia }}</td>
                                <td class="border px-4 py-2">{{ $report->POSVcbMedproAsia }}</td>
                                <td class="border px-4 py-2">{{ $report->Debit }}</td>
                                <td class="border px-4 py-2">{{ $report->Ktv }}</td>
                                <td class="border px-4 py-2">{{ $report->Nursing }}</td>
                                <td class="border px-4 py-2">{{ $report->RevenueConsultant }}</td>
                                <td class="border px-4 py-2">{{ $report->Doctor }}</td>
                                <td class="border px-4 py-2">{{ $report->Nurse }}</td>
                                <td class="border px-4 py-2">{{ $report->Cashier }}</td>
                                <td class="border px-4 py-2">{{ $report->CustomerServiceStaff }}</td>
                                <td class="border px-4 py-2">{{ $report->CustomerType }}</td>
                                <td class="border px-4 py-2">{{ $report->Note }}</td>
                            </tr>
                            @php $stt++; @endphp
                        @endforeach
                    </tbody>
                </table>
                <div class="mt-4">
                    {{-- {{ $reports->links() }} --}}
                </div>
            </div>
        </div>
    </div>
</x-app-layout>

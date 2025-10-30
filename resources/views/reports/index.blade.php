<style>
    table thead {
        background-color: aliceblue;
    }

    #reports-table th,
    #reports-table td {
        white-space: nowrap; /* Không cho xuống dòng */
        vertical-align: middle; /* Căn giữa theo chiều dọc */
    }
    table.dataTable thead th {
        text-align: center !important;
        vertical-align: middle !important;
    }

    /* Giới hạn chiều rộng */
    div.dataTables_wrapper {
        overflow-x: auto;
    }

    /* Giãn khoảng cách các phần */
    div.dataTables_wrapper div.dataTables_length select {
        width: auto; /* Giữ kích thước tự nhiên */
        display: inline-block;
        margin: 0 5px;
    }

    div.dataTables_wrapper div.dataTables_filter input {
        width: 200px; /* Đặt độ rộng hợp lý cho ô tìm kiếm */
    }

    div.dataTables_wrapper div.dataTables_length label,
    div.dataTables_wrapper div.dataTables_filter label {
        white-space: nowrap;
        margin-bottom: 0;
    }

    /* Giúp nút Excel nằm cân đối */
    .dt-buttons .btn {
        margin-left: 5px;
    }

    select.dt-input {
        -webkit-appearance: none;  /* Safari/Chrome */
        -moz-appearance: none;     /* Firefox */
        appearance: none;          /* Chuẩn */
        background-image: none !important; /* Ẩn icon mũi tên mặc định */
        padding-right: 10px;       /* Canh nội dung không bị chèn */
    }
</style>

<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Báo cáo thô') }}
        </h2>
    </x-slot>

    <div class="py-6">
        <div class="w-full mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6">
                {{-- Form lọc --}}
                <form id="filter-form" class="mb-4">
                    <div class="form-row align-items-end">
                        <!-- Từ ngày -->
                        <div class="form-group col-md-2">
                            <label for="start_date" class="d-block">Từ ngày</label>
                            <input 
                                type="date" 
                                id="start_date" 
                                name="start_date" 
                                class="form-control form-control-sm"
                                @isset($filters['start_date']) 
                                    value="{{ date('Y-m-d', strtotime($filters['start_date'])) }}" 
                                @endisset
                            >
                        </div>
                
                        <!-- Đến ngày -->
                        <div class="form-group col-md-2">
                            <label for="end_date" class="d-block">Đến ngày</label>
                            <input 
                                type="date" 
                                id="end_date" 
                                name="end_date" 
                                class="form-control form-control-sm"
                                @isset($filters['end_date']) 
                                    value="{{ date('Y-m-d', strtotime($filters['end_date'])) }}" 
                                @endisset
                            >
                        </div>
                
                        <!-- Cơ sở -->
                        <div class="form-group col-md-3">
                            <label for="site_id" class="d-block">Cơ sở</label>
                            <select 
                                id="site_id" 
                                name="site_id" 
                                class="form-control form-control-sm border border-secondary" 
                            >
                                <option value="">-- Tất cả --</option>
                                @foreach ($sites as $item)
                                    <option 
                                        value="{{ $item->IDPhongBan }}" 
                                        @isset($filters['site_id'])
                                            @if (in_array($item->IDPhongBan, $filters['site_id']))
                                                selected
                                            @endif
                                        @endisset
                                    >
                                        {{ $item->TenPhongBan }}
                                    </option>
                                @endforeach
                            </select>
                        </div>
                
                        <!-- Nút Lọc -->
                        <div class="form-group col-md-2 text-left">
                            <button type="submit" class="btn btn-primary btn-sm mt-4">
                                <i class="fa fa-filter mr-1"></i> Lọc
                            </button>
                        </div>
                    </div>
                </form>                

                {{-- Bảng --}}
                <table id="reports-table" class="min-w-full border border-gray-200"></table>
            </div>
        </div>
    </div>

    <script>
        $(function() {

            let table = $('#reports-table').DataTable({
                processing: true,
                serverSide: true,
                ajax: {
                    url: '{{ route('reports.data') }}',
                    type: 'POST',
                    data: function (d) {
                        d.start_date = $('#start_date').val();
                        d.end_date = $('#end_date').val();
                        d.site_id = $('#site_id').val();
                        d._token = $('meta[name="csrf-token"]').attr('content');
                    },
                    beforeSend: function() {
                        $('#loading-overlay').show();
                    },
                    complete: function() {
                        $('#loading-overlay').hide();
                    }
                },
                dom:
                    "<'row align-items-center mb-3'<'col-md-4 d-flex align-items-center'l><'col-md-4 text-center'f><'col-md-4 text-right'B>>" +
                    "<'row'<'col-sm-12'tr>>" +
                    "<'row mt-2'<'col-md-5'i><'col-md-7'p>>",
                buttons: [
                    { 
                        text: '<i class="fa fa-file-excel"></i> Xuất Excel', 
                        className: 'btn btn-success btn-sm', 
                        action: function () {
                            const params = $.param({
                                start_date: $('#start_date').val(),
                                end_date: $('#end_date').val(),
                                site_id: $('#site_id').val()
                            });
                            window.location.href = '{{ route("reports.export") }}?' + params;
                        }
                    },
                ],
                columns: [
                    { data: 'DateOfApplication', title: 'Ngày tháng' },
                    { data: 'SiteName', title: 'Cơ sở' },
                    { data: 'Type', title: 'Loại' },
                    { data: 'Order', title: 'Order' },
                    { data: 'CardNumber', title: 'Số thẻ' },
                    { data: 'CustomerName', title: 'Tên khách hàng' },
                    { data: 'GroupType', title: 'Loại nhóm' },
                    { data: 'RevenueType', title: 'Loại doanh thu' },
                    { data: 'ProductGroup', title: 'Nhóm sản phẩm' },
                    { data: 'Code', title: 'Mã' },
                    { data: 'Description', title: 'Diễn giải' },
                    { data: 'UnitPrice', title: 'Đơn giá', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'Quantity', title: 'Số lượng' },
                    { data: 'Total', title: 'Thành tiền', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'DiscountPercent', title: 'Chiết khấu', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'DiscountAmount', title: 'Chiết khấu(số tiền)', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'PaymentAmount', title: 'Số tiền thanh toán', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'DeductfromAccountCard', title: 'Trừ thẻ TK', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'ExceptionalPayment', title: 'Thanh toán ngoại lệ', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'DeductfromDeposit', title: 'Cấn trừ đặt cọc', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'CashBranches', title: 'TM các chi nhánh', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'PaymentGBPBranches', title: 'Thanh toán GBP các chi nhánh', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'PaymentUSDBranches', title: 'Thanh toán USD các chi nhánh', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'PaymentAUDBranches', title: 'Thanh toán AUD(Úc) chi nhánh', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'PaymentSGDBranches', title: 'Thanh toán SGD(Singapore) chi nhánh', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'PaymentJPYBranches', title: 'Thanh toán JPY(Nhật) chi nhánh', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'PaymentCADbranch', title: 'Thanh toán CAD(Canada) chi nhánh', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'BranchEURPayment', title: 'Thanh toán EUR chi nhánh', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'TransferMegaHN', title: 'CK CT MEGA - CN HN', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'TransferMegaHCM', title: 'CK CT MEGA - CN HCM', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'TransferBIDVMedproAsia', title: 'CK BIDV - CT MEDPRO ASIA', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'TransferSacombankMedproAsia', title: 'CK Sacombank - CT MEDPRO ASIA', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'TransferVcbMedproAsia', title: 'CK VCB - CT MEDPRO ASIA', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'POSMegaHN', title: 'POS CT MEGA - CN HN', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'POSMegaHCM', title: 'POS CT MEGA - CN HCM', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'POSBIDVMedproAsia', title: 'POS BIDV - CT MEDPRO ASIA', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'POSSacombankMedproAsia', title: 'POS Sacombank - CT MEDPRO ASIA', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'POSVcbMedproAsia', title: 'POS VCB - CT MEDPRO ASIA', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'Debit', title: 'Ghi nợ', render: $.fn.dataTable.render.number(',', '.', 0) },
                    { data: 'Ktv', title: 'KTV' },
                    { data: 'Nursing', title: 'Điều dưỡng' },
                    { data: 'RevenueConsultant', title: 'TVDT (Tư vấn doanh thu' },
                    { data: 'Doctor', title: 'Bác Sĩ' },
                    { data: 'Nurse', title: 'Y tá' },
                    { data: 'Cashier', title: 'Thu Ngân' },
                    { data: 'CustomerServiceStaff', title: 'CSKH' },
                    { data: 'CustomerType', title: 'Loại khách hàng' },
                    { data: 'Note', title: 'Ghi chú' },
                ],
                language: {
                    search: "<i class='ti-search'></i>",
                    searchPlaceholder: "Tìm kiếm",
                    lengthMenu: "Hiển thị _MENU_ dòng",
                    info: "Trang _PAGE_ / _PAGES_",
                    zeroRecords: "Không có dữ liệu phù hợp",
                    paginate: { previous: "Trước", next: "Sau" }
                },
                scrollX: true
            });

            // Khi nhấn "Lọc" thì reload DataTable
            $('#filter-form').on('submit', function(e) {
                e.preventDefault();
                table.ajax.reload();
            });
        });
    </script>
</x-app-layout>

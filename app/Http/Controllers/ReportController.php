<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;
use App\Services\ReportService;
use Maatwebsite\Excel\Facades\Excel;

class ReportController extends Controller
{
    protected $reportService;

    public function __construct(ReportService $reportService)
    {
        $this->reportService = $reportService;
    }
    public function index()
    {
        $option = [];
        if (isset($_GET['start_date'])) {
            if ($_GET['start_date'] != '') {
                $option['start_date'] = $_GET['start_date'];
            }
        }
        if (isset($_GET['end_date'])) {
            if ($_GET['end_date'] != '') {
                $option['end_date'] = $_GET['end_date'];
            }
        }
        if (isset($_GET['site_id'])) {
            if ($_GET['site_id'] != '') {
                $option['site_id'] = $_GET['site_id'];
            }
        }
        $data['filters'] = $option;
        $data['sites'] = $this->reportService->getSites();
        // dd($data);
        return view('reports.index', $data);
    }

    public function getData(Request $request)
    {
        $startDate = $request->input('start_date', now()->startOfMonth());
        $endDate = $request->input('end_date', now()->endOfMonth());
        $siteID = $request->input('site_id');

        $reports = $this->reportService->getReports($startDate, $endDate, $siteID);

        return DataTables::of($reports)
        ->make(true);
    }

    public function export(Request $request)
    {
        // Lấy điều kiện lọc giống trong DataTable
        $startDate = $request->start_date;
        $endDate = $request->end_date;
        $siteID = $request->site_id;

        $data = $this->reportService->getReports($startDate, $endDate, $siteID);

        // Xuất bằng maatwebsite/excel
        return Excel::download(new \App\Exports\ReportsExport($data), 'BaoCao.xlsx');
    }
}

<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;
use App\Services\ReportService;
use Maatwebsite\Excel\Facades\Excel;
use Carbon\Carbon;

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
        } else {
            $option['start_date'] = now()->startOfMonth()->format('Y-m-d');
        }
        if (isset($_GET['end_date'])) {
            if ($_GET['end_date'] != '') {
                $option['end_date'] = $_GET['end_date'];
            }
        } else {
            $option['end_date'] = now()->endOfMonth()->format('Y-m-d');
        }
        if (isset($_GET['site_id'])) {
            if ($_GET['site_id'] != '') {
                $option['site_id'] = $_GET['site_id'];
            }
        }

        // Apply role-based site restriction
        /** @var \App\Models\User $user */
        $user = auth()->user();
        $allowedSiteIds = $user->getAllowedSiteIds();

        // dd($option);
        $data['filters'] = $option;
        $sites = $this->reportService->getSites();
        if (!empty($allowedSiteIds)) {
            foreach ($sites as $key => $site) {
                if (!in_array($site->IDPhongBan, $allowedSiteIds)) {
                    unset($sites[$key]);
                }
            }
        }
        $data['sites'] = $sites;
        // dd($data);
        return view('reports.index', $data);
    }

    public function getData(Request $request)
    {
        $startDate = $request->input('start_date', now()->startOfMonth());
        $endDate = $request->input('end_date', now()->endOfMonth());
        $siteID = $request->input('site_id');

        /** @var \App\Models\User $user */
        $user = auth()->user();
        $allowedSiteIds = $user->getAllowedSiteIds();
        if (empty($siteID) && !empty($allowedSiteIds)) {
            $siteID = $allowedSiteIds;
        }

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

        /** @var \App\Models\User $user */
        $user = auth()->user();
        $allowedSiteIds = $user->getAllowedSiteIds();
        if (empty($siteID) && !empty($allowedSiteIds)) {
            $siteID = $allowedSiteIds;
        }

        // $data = $this->reportService->getReports($startDate, $endDate, $siteID);

        // Xuất bằng maatwebsite/excel
        return Excel::download(new \App\Exports\ReportsExport($startDate, $endDate, $siteID), 'BaoCao.xlsx');
    }
}

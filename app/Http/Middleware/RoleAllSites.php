<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use App\Models\Role;
use Symfony\Component\HttpFoundation\Response;

class RoleAllSites
{
    /**
     * Handle an incoming request.
     * Only allow users with ROLE_ALL_SITES to pass through.
     */
    public function handle(Request $request, Closure $next): Response
    {
        /** @var \App\Models\User $user */
        $user = $request->user();

        if (!$user || !$user->role || $user->role->role_type !== Role::ROLE_ALL_SITES) {
            abort(403, 'Bạn không có quyền truy cập trang này.');
        }

        return $next($request);
    }
}

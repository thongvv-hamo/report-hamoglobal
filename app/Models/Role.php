<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Role extends Model
{
    use HasFactory;

    /**
     * Role type: user can search data in all sites.
     */
    const ROLE_ALL_SITES = 0;

    /**
     * Role type: user can only search data by the site_ids in their role_permissions.
     */
    const ROLE_SITE_RESTRICTED = 1;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'role_type',
    ];

    /**
     * Get the users assigned to this role.
     */
    public function users()
    {
        return $this->hasMany(User::class, 'role_id');
    }

    /**
     * Get the site permissions associated with this role.
     */
    public function permissions()
    {
        return $this->hasMany(RolePermission::class, 'role_id');
    }

    /**
     * Determine if this role allows access to all sites.
     */
    public function canAccessAllSites(): bool
    {
        return $this->role_type === self::ROLE_ALL_SITES;
    }
}

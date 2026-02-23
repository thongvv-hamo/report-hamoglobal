<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RolePermission extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'role_id',
        'site_id',
    ];

    /**
     * Get the role that owns this permission.
     */
    public function role()
    {
        return $this->belongsTo(Role::class, 'role_id');
    }
}

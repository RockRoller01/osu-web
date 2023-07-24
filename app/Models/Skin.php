<?php

// Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the GNU Affero General Public License v3.0.
// See the LICENCE file in the repository root for full licence text.

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\Forum\Topic;

class Skin extends Model
{
    use SoftDeletes;

    public function topic()
    {
        return $this->belongsTo(Topic::class, 'topic_id');
    }
}

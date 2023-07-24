<?php

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

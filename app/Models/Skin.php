<?php

namespace App\Models;

use Cache;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\Forum\Topic;

class Skin extends Model
{
    use SoftDeletes;

    public static function latestSkins($count = 5){
        return Cache::remember("skins_latest_{$count}", 3600, function () use ($count) {
            return self::limit($count)->get();
        });
    }

    public function topic()
    {
        return $this->belongsTo(Topic::class, 'topic_id');
    }
}

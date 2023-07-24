<?php

namespace App\Models;

use Cache;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\Forum\Topic;
use App\Libraries\StorageWithUrl;

class Skin extends Model
{
    use SoftDeletes;

    public static function latestSkins($count = 5){
        return Cache::remember("skins_latest_{$count}", 3600, function () use ($count) {
            return self::limit($count)->get();
        });
    }

    public function coverURL($coverSize = 'cover')
    {
        return $this->storage()->url($this->coverPath()."{$coverSize}.jpg");
    }

    public function coverPath()
    {
        $id = $this->getKey() ?? 0;

        return "skins/{$id}/covers/";
    }

    public function storage()
    {
        if ($this->_storage === null) {
            $this->_storage = new StorageWithUrl();
        }

        return $this->_storage;
    }

    public function playmodes()
    {
        $playModes = [];

        if ($this->osu)
        {
            array_push($playModes, "osu");
        }
        if ($this->taiko)
        {
            array_push($playModes, "taiko");
        }
        if ($this->fruits)
        {
            array_push($playModes, "fruits");
        }
        if ($this->mania)
        {
            array_push($playModes, "mania");
        }

        return $playModes;
    }

    public function topic()
    {
        return $this->belongsTo(Topic::class, 'topic_id');
    }
}

<?php

// Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the GNU Affero General Public License v3.0.
// See the LICENCE file in the repository root for full licence text.

namespace Tests\Models;

use App\Models\Group;
use App\Models\UserGroupEvent;
use Tests\TestCase;

class GroupTest extends TestCase
{
    public function testRename()
    {
        $newName = 'new name';
        $group = factory(Group::class)->create(['group_name' => 'name']);

        $group->rename($newName);

        $this->assertSame($group->group_name, $newName);
        $this->assertSame(
            UserGroupEvent::where([
                'group_id' => $group->getKey(),
                'type' => UserGroupEvent::GROUP_RENAME,
            ])->count(),
            1,
        );
    }

    public function testRenameUnchanged()
    {
        $name = 'name';
        $group = factory(Group::class)->create(['group_name' => $name]);

        $group->rename($name);

        $this->assertSame(
            UserGroupEvent::where([
                'group_id' => $group->getKey(),
                'type' => UserGroupEvent::GROUP_RENAME,
            ])->count(),
            0,
        );
    }
}

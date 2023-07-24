{{--
    Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the GNU Affero General Public License v3.0.
    See the LICENCE file in the repository root for full licence text.
--}}

<a class="user-home-skin" href="{{route('forum.topics.show', $skin->topic_id)}}">
    @include('objects._skin_cover', [
        'skin' => $skin,
        'modifiers' => 'home',
        'size' => 'list',
    ])

    <div class="user-home-skin__meta">
        <div class="user-home-skin__title-container">
            @foreach ($skin->playmodes() as $playmode)
                <div class="user-home-skin__playmode-icon">
                    <span class="fal fa-extra-mode-{{$playmode}}"></span>
                </div>
            @endforeach

            <div class='user-home-skin__title u-ellipsis-overflow'>
                {{ $skin->name }}
            </div>
        </div>

        <div class="user-home-skin__creator u-ellipsis-overflow">
            {!! osu_trans('home.user.beatmaps.by_user', ['user' => tag(
                'span',
                ['data-user-id' => $skin->topic->topic_poster , 'class' => 'js-usercard'],
                e($skin->topic->topic_first_poster_name)
            )]) !!}  
        </div>
    </div>
    <div class="user-home-skin__chevron"><i class='fas fa-chevron-right'></i></div>
</a>
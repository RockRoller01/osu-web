{{--
    Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the GNU Affero General Public License v3.0.
    See the LICENCE file in the repository root for full licence text.
--}}
@php
    $class = class_with_modifiers('skin-cover', $modifiers);
    $style = css_var_2x('--bg', $skin->coverURL($size));
@endphp
<div class="{{ $class }}" style="{{ $style }}"></div>
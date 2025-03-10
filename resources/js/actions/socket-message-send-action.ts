// Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the GNU Affero General Public License v3.0.
// See the LICENCE file in the repository root for full licence text.

import DispatcherAction from 'actions/dispatcher-action';

interface Message {
  event: string;
}

export default class SocketMessageSendAction implements DispatcherAction {
  constructor(public message: Message) {}
}

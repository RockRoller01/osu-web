// Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the GNU Affero General Public License v3.0.
// See the LICENCE file in the repository root for full licence text.

import { htmlElementOrNull } from 'utils/html';
import { parseJson } from 'utils/json';
import { presence } from 'utils/string';

type Languages = string[];

const currentStorageKey = 'docs-example-language';

export default class SetLanguage {
  private languages: Languages;

  constructor() {
    try {
      this.languages = parseJson<Languages>(document.body.dataset.languages ?? '');
    } catch {
      this.languages = ['bash'];
    }
    this.language = this.currentLanguage();

    document.addEventListener('click', this.updateLanguage);
  }

  private currentLanguage() {
    return presence(window.localStorage.getItem(currentStorageKey)) ?? this.languages[0];
  }

  private set language(newLanguage: string) {
    window.localStorage.setItem(currentStorageKey, newLanguage);
    document.body.dataset.language = newLanguage;
  }

  private readonly updateLanguage = (event: MouseEvent) => {
    const button = htmlElementOrNull(htmlElementOrNull(event.target)?.closest('.js-set-language'));
    if (button == null) return;

    this.language = button.dataset.languageName ?? '';
  };
}

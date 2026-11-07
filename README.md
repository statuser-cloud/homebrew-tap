# Statuser в Homebrew

Это тап Homebrew организации Statuser. Через него ставится консольная утилита [statuser](https://github.com/statuser-cloud/cli) на macOS и Linux.

## Установка

Тап подключается автоматически при первой установке по полному имени формулы:

```sh
brew install statuser-cloud/tap/statuser
```

Автодополнение для bash, zsh и fish ставится вместе с формулой, настраивать его отдельно не нужно.

## Обновление

Новая версия ставится обычной командой Homebrew:

```sh
brew upgrade statuser
```

Формула сама следит за релизами [statuser-cloud/cli](https://github.com/statuser-cloud/cli/releases): раз в шесть часов GitHub Actions проверяет последний релиз, обновляет версию и контрольные суммы в `Formula/statuser.rb` и публикует изменение только после того, как формула прошла `brew audit`, установку и `brew test`.

## Структура

Формулы лежат в `Formula/<имя>.rb`, каски — в `Casks/<имя>.rb`. Новая формула подключается к автообновлению строкой в матрице `.github/workflows/update-formulas.yml`, если её релизы публикуют `SHA256SUMS` и архивы `<имя>-<macos|linux>-<arm64|x64>.tar.gz`.

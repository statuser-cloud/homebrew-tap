# Statuser в Homebrew

Через этот тап ставится [CLI Statuser](https://github.com/statuser-cloud/cli) — утилита командной строки для мониторинга Statuser: серверы и сценарные проверки как код, пауза проверок на время деплоя, плановые работы и heartbeat для крон-задач. Работает на macOS и Linux, Node.js для неё не нужен.

## Установка

Тап подключается сам при первой установке:

```sh
brew install statuser-cloud/tap/statuser
```

Вместе с утилитой ставится автодополнение для bash, zsh и fish. Оно заработает в новой сессии оболочки.

## Обновление

Новые версии ставятся обычной командой Homebrew:

```sh
brew upgrade statuser
```

## Первый запуск

Сохраните API-ключ из панели Statuser командой `statuser login`. Дальше — раздел «Быстрый старт» в [README утилиты](https://github.com/statuser-cloud/cli#быстрый-старт).

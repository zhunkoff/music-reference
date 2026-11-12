[English](BUILD.md) | Русский

# Сборка PDF

Руководство описывает установку инструментов в Windows, Linux и macOS и сборку
документов из исходников TeX. Вернуться к [обзору проекта](README.ru.md).

## Необходимые инструменты

Команды проекта описаны в `justfile` и используют `latexmk`, который запускает
LuaLaTeX необходимое число раз. Для таблицы гитарных аккордов используются TikZ,
Babel с данными английского и русского языков и шрифты DejaVu Sans Condensed
обычного и жирного начертаний.
[Документация latexmk](https://www.cantab.net/users/johncollins/latexmk/index.html).

| Компонент | Пакет TeX Live |
| --- | --- |
| Автоматизация сборки | `latexmk` |
| Движок LuaLaTeX и механизм загрузки шрифтов | `luatex`, `luaotfload` |
| Схемы TikZ | `pgf` |
| Поддержка языков | `babel`, `babel-english`, `babel-russian` |
| Английские и русские переносы | `hyphen-english`, `hyphen-russian` |
| Выбор шрифтов | `fontspec` |
| Шрифты DejaVu Sans Condensed | `dejavu` |
| Разметка страницы и вспомогательные команды | `geometry`, `etoolbox`, `hyperref` |

Полная установка TeX Live включает эти компоненты и их зависимости. Для загрузки
и установки потребуется несколько гигабайт. В инструкции для Gentoo необходимые
коллекции выбираются настройками Portage. Уже установленное окружение можно
проверить командами из раздела [«Проверка установки»](#проверка-установки).

Установите `just` отдельно по инструкции для своей платформы ниже. Для систем
со старыми репозиториями пакетов также доступны официальные бинарные файлы.
[Установка just](https://just.systems/man/en/installation.html).

## Установка инструментов

### Windows

1. Скачайте `install-tl-windows.exe` со страницы сетевой установки TeX Live.
2. Запустите установщик и выберите полную схему установки `scheme-full`.
3. Оставьте включённым добавление TeX Live в путь поиска исполняемых файлов
   и завершите установку.
4. Установите `just` из PowerShell с помощью Windows Package Manager.

```powershell
winget install --id Casey.Just --exact
```

После установки откройте новое окно PowerShell и выполните проверки ниже.
В Windows команды проекта выполняются через PowerShell.
[Пакеты just](https://just.systems/man/en/packages.html).

Установщик и инструкции для платформы поддерживает TeX Users Group.
[Сетевой установщик TeX Live](https://tug.org/texlive/acquire-netinstall.html),
[TeX Live для Windows](https://tug.org/texlive/windows.html).

### Linux

Приведённые ниже команды предназначены для Debian/Ubuntu, Fedora, Gentoo
и SUSE/openSUSE. Выполните команды для своего дистрибутива в терминале.

#### Debian 13+ и Ubuntu 24.04+

```sh
sudo apt update
sudo apt install texlive-full just
```

Пакет `texlive-full` устанавливает коллекции TeX Live, доступные в дистрибутиве.
Поставляемый выпуск зависит от версии операционной системы.
[Пакет Debian](https://packages.debian.org/trixie/texlive-full),
[Пакет Ubuntu](https://packages.ubuntu.com/noble/texlive-full).

#### Fedora

```sh
sudo dnf install texlive-scheme-full just
```

Этот пакет устанавливает полную схему TeX Live из Fedora.
[Пакет Fedora](https://packages.fedoraproject.org/pkgs/texlive/texlive-scheme-full/).

В перечисленных выше дистрибутивах пакет `just` доступен через `apt` и `dnf`.
[Пакеты just](https://just.systems/man/en/packages.html).

#### Gentoo

Добавьте следующую запись в конфигурацию `/etc/portage/package.use`. Если этот
путь является каталогом, поместите запись в отдельный файл, например
`/etc/portage/package.use/texlive`.

```text
app-text/texlive extra graphics luatex l10n_en l10n_ru
```

Эти флаги выбирают дополнительные шрифты и пакеты LaTeX, графические пакеты,
LuaTeX и коллекции для английского и русского языков.
[Пакет TeX Live в Gentoo](https://packages.gentoo.org/packages/app-text/texlive).

Выполните команду установки от имени root.

```sh
emerge --ask app-text/texlive dev-tex/latexmk dev-build/just
```

Portage установит выбранные коллекции TeX Live и оба инструмента сборки.
[Пакет latexmk в Gentoo](https://packages.gentoo.org/packages/dev-tex/latexmk),
[Пакет just в Gentoo](https://packages.gentoo.org/packages/dev-build/just).

#### SUSE / openSUSE

На SUSE Linux Enterprise подключите расширение Package Hub для зарегистрированного
выпуска системы. Выведите список расширений и выполните показанную команду
активации Package Hub для своего сервис-пака и архитектуры.
[Подключение SUSE Package Hub](https://packagehub.suse.com/how-to-use/).

```sh
sudo SUSEConnect --list-extensions
```

На openSUSE используйте репозитории, настроенные для своего выпуска. На обеих
системах обновите метаданные репозиториев и проверьте доступность нужных пакетов.

```sh
sudo zypper refresh
zypper search -s texlive-scheme-full
zypper search -s texlive-latexmk-bin
zypper search -s just
```

Установите полную схему TeX Live, пакет исполняемого файла `latexmk` и `just`.

```sh
sudo zypper install texlive-scheme-full texlive-latexmk-bin just
```

Доступность пакетов зависит от выпуска и подключённых репозиториев. В каталоге
SUSE перечислены схема TeX Live, пакеты исполняемых файлов и `just`.
[Схемы TeX Live](https://packagehub.suse.com/packages/texlive-filesystem/),
[Исполняемые файлы TeX Live](https://packagehub.suse.com/packages/texlive/),
[Пакет just](https://packagehub.suse.com/packages/just/).

Если пакет отсутствует для вашего выпуска, используйте установщик TeX Live
и официальные бинарные файлы `just` по ссылкам в этом руководстве, затем выполните
приведённые ниже проверки установки.

Для других дистрибутивов Linux или установки актуального выпуска TeX Live напрямую
следуйте руководству установщика TeX Users Group. После установки добавьте
выведенный установщиком каталог исполняемых файлов в `PATH` своей оболочки.
[Руководство по установке TeX Live](https://tug.org/texlive/quickinstall.html).

Если при установке TeX Live напрямую пакет `latexmk` был пропущен, добавьте его
командой `tlmgr install latexmk` с правами, соответствующими этой установке.

### macOS

1. Скачайте `MacTeX.pkg` со страницы загрузки MacTeX.
2. Запустите установщик пакета и включите полный компонент TeX Live.
3. Установите `just` через Homebrew или из официального бинарного файла по ссылке выше.
4. Откройте новое окно Terminal и выполните проверки установки, приведённые ниже.

MacTeX содержит дистрибутив TeX Live и настраивает его инструменты командной строки.
[Загрузка MacTeX](https://tug.org/mactex/mactex-download.html).

Если вы уже используете Homebrew, оба инструмента можно установить следующими
командами. После их завершения откройте новое окно Terminal.
[Пакет MacTeX для Homebrew](https://formulae.brew.sh/cask/mactex),
[Пакеты just](https://just.systems/man/en/packages.html).

```sh
brew install --cask mactex
brew install just
```

## Проверка установки

В PowerShell на Windows проверьте, какой исполняемый файл будет запущен.

```powershell
Get-Command just
Get-Command latexmk
Get-Command lualatex
```

В Bash или Zsh на Linux/macOS используйте следующую команду.

```sh
command -v just latexmk lualatex
```

Остальные проверки подходят для PowerShell, Bash и Zsh. Каждая команда `kpsewhich`
должна вывести путь к запрошенному файлу.

```sh
just --version
latexmk -v
lualatex --version
kpsewhich fontspec.sty
kpsewhich babel.sty
kpsewhich babel-english.tex
kpsewhich babel-russian.tex
kpsewhich tikz.sty
kpsewhich DejaVuSansCondensed.ttf
kpsewhich DejaVuSansCondensed-Bold.ttf
kpsewhich geometry.sty
kpsewhich etoolbox.sty
kpsewhich hyperref.sty
```

## Сборка документов

Скачайте или клонируйте репозиторий и откройте PowerShell на Windows либо терминал
с Bash/Zsh на Linux/macOS в корневом каталоге репозитория. На каждой платформе
используются одинаковые команды `just`.

```sh
just build
just build ru
just build-all
```

| Команда | Действие |
| --- | --- |
| `just build` или `just build en` | Собрать все зарегистрированные документы на английском |
| `just build ru` | Собрать все зарегистрированные документы на русском |
| `just build-all` | Собрать все зарегистрированные документы на обоих языках |
| `just build en false` | Собрать документы на английском без номеров пальцев |
| `just build ru false` | Собрать документы на русском без номеров пальцев |
| `just build-all false` | Собрать оба языка без номеров пальцев |
| `just clean` | Удалить вспомогательные файлы зарегистрированных документов |
| `just --list` | Показать доступные команды |

По умолчанию выбран английский язык. `latexmk` автоматически выполняет повторные
проходы и проверяет необходимость пересборки. Повторный `just build` после успешной
сборки использует актуальные результаты.

Готовые PDF записываются рядом с исходником TeX каждого документа. Для таблицы
гитарных аккордов файлы появятся в `guitar/chords`.

| Файл | Содержимое |
| --- | --- |
| `6-string-standard-tuning.en.pdf` | Таблица на английском |
| `6-string-standard-tuning.ru.pdf` | Таблица на русском |
| `6-string-standard-tuning.en-dots.pdf` | Таблица на английском без номеров пальцев |
| `6-string-standard-tuning.ru-dots.pdf` | Таблица на русском без номеров пальцев |

По умолчанию номера пальцев видны. Необязательный второй аргумент `just build`
принимает `true` или `false`; `just build-all` принимает тот же аргумент после
имени команды. Например:

```sh
just build ru false
just build-all false
```

Варианты `false` получают суффикс `-dots` и сохраняются отдельно от PDF с номерами.
Скрываются только цифры пальцев внутри точек, включая точки на баррэ. Точки,
баррэ, номера ладов и обозначения открытых и заглушённых струн сохраняют положение.
В пояснении описываются точки без цифр вместо номеров пальцев.

При прямой сборке LuaLaTeX определите `\ShowFingerNumbers` как `false` до загрузки
исходника. Значение по умолчанию — `true`. Недопустимые значения языка или показа
номеров пальцев прерывают сборку с ошибкой.

Каждый PDF содержит две страницы A4 в альбомной ориентации и всего 96 схем
аккордов. Откройте PDF в программе просмотра и проверьте язык, символы, номера
пальцев и расположение элементов. Для проверки печати выберите A4, альбомную
ориентацию и масштаб 100% / фактический размер.

LaTeX и `latexmk` также создают файлы `.aux`, `.log`, `.out`, `.fls` и `.fdb_latexmk`
с тем же именем задания. В `.log` записываются ошибки и предупреждения.
Вспомогательные файлы перечислены в `.gitignore` и удаляются командой очистки.

```sh
just clean
```

В таблице используются цифры пальцев фиксированного размера 6,8 пункта
с утолщёнными штрихами для читаемости при печати. Размер и начертание шрифта
заданы в оформлении документа и не требуют параметров сборки.

### Добавление документа

Добавьте путь к главному исходнику TeX каждого документа в `@default_files`
в [`latexmkrc`](latexmkrc), относительно корня репозитория. Команды `just build`,
`just build-all` и `just clean` используют этот список. В том же файле хранятся
общие настройки LuaLaTeX. Двуязычные документы могут использовать
`\ChartLanguage` со значениями `en` и `ru`, как в исходнике гитарной таблицы.
В документах с аппликатурами можно использовать `\ShowFingerNumbers` (`true`
или `false`), чтобы поддерживать варианты с номерами и с точками без цифр.

## Устранение ошибок

| Признак | Действие |
| --- | --- |
| Команда `just` или `latexmk` недоступна | Установите инструмент по инструкции для своей платформы выше, откройте новую оболочку и проверьте путь к исполняемому файлу. |
| Команда `lualatex` недоступна | Откройте новую оболочку и проверьте путь к исполняемому файлу. На Windows проверьте настройку пути поиска в установщике TeX Live. На Linux используйте каталог, указанный установщиком TeX Live, если устанавливали его напрямую. |
| Отсутствует файл `.sty` или локаль Babel | Найдите файл через `kpsewhich`. Установите соответствующий пакет через TeX Live Manager / TeX Live Utility из MacTeX либо через менеджер пакетов дистрибутива Linux (`apt`, `dnf`, `emerge` или `zypper`). |
| Шрифт DejaVu Sans Condensed не найден | Проверьте оба файла `.ttf` через `kpsewhich` и установите пакет TeX Live `dejavu`. Исходник загружает эти файлы шрифтов из установки TeX. |
| Исходный файл TeX не найден | Проверьте путь в `@default_files` в `latexmkrc`. Запустите `just` из корня репозитория или вложенного каталога. |
| Сборка прерывается с ошибкой LaTeX | Прочитайте первую ошибку в соответствующем файле `.log`. Проверьте `lualatex --version` и перечисленные выше пакеты. |

На macOS активные исполняемые файлы MacTeX доступны через `/Library/TeX/texbin`.
Если команда недоступна в новом окне Terminal, проверьте этот каталог и настройку
`PATH`. [Подробности установки MacTeX](https://tug.org/mactex/What_Is_Installed.pdf).

Обновления установки из дистрибутива Linux выполняются его менеджером пакетов.
Для установки TeX Live напрямую используется `tlmgr`.
[Документация TeX Live Manager в Debian](https://manpages.debian.org/unstable/texlive-base/tlmgr.1.en.html).

## Проверенное окружение

Английская и русская версии с номерами пальцев и без них, инкрементальная сборка
и очистка проверены на macOS 26.7.1 (Apple Silicon) с LuaHBTeX 1.21.0 из TeX Live
2025, `latexmk` 4.86a и `just` 1.21.0 и 1.59.0. Обе языковые версии содержат
по две страницы. Инструкции по установке в Windows и Linux сверены с документацией
поставщиков. Выполнение на этих платформах ещё предстоит проверить.

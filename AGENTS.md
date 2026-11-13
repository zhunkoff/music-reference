# Repository guidance

`music-reference` contains music reference charts and documents. Organize materials
by instrument and topic, with each document's PDF and TeX source stored together.

## TeX sources and languages

- Use one TeX source for each bilingual document, with shared musical data,
  diagrams, and layout, and explicit English and Russian text.
- Keep English as the default language. Use `\ChartLanguage` with `en` and `ru`
  for language selection.
- Preserve the document's established visual style when making changes.

## Documentation

- Keep `README.md` and `README.ru.md` consistent when their content changes.
- Keep `BUILD.md` and `BUILD.ru.md` consistent when build instructions change,
  including matching command examples and working language links.
- Refer to [BUILD.md](BUILD.md) for tool installation and detailed build commands.

## GitHub issues and pull requests

- Before creating an issue, read the relevant local form in
  [.github/ISSUE_TEMPLATE](.github/ISSUE_TEMPLATE). Use
  [task.yml](.github/ISSUE_TEMPLATE/task.yml) for tasks and new material, and
  [bug_report.yml](.github/ISSUE_TEMPLATE/bug_report.yml) for errors.
- Before creating a pull request, read
  [pull_request_template.md](.github/pull_request_template.md).
- Follow the template's fields and section headings when writing the body,
  including when creating issues or pull requests through a CLI or API.
- Write issue and pull request titles and descriptions in English by default,
  unless the user requests another language.
- Distinguish agreed requirements from proposals and unresolved questions.

## Build and verification

- Use the project's `just` recipes for standard builds and cleanup.
- Register each new document's main TeX source in `@default_files` in
  [latexmkrc](latexmkrc), using a path relative to the repository root.
- After changing TeX, run `just build-all` and visually inspect both language
  PDFs. Check page layout, symbols, finger numbers, clipping, and overlaps.
- For documentation changes, check local links and agreement between translations.

## Musical accuracy

- When editing chord diagrams, verify sounding notes against chord names,
  accounting for valid voicings with omitted tones.
- Check the tuning, string order, fret numbers, starting fret, open and muted
  strings, barre spans, and finger assignments.

## Attribution and license

- Preserve attribution to **Sergey Zhunkov** and the **CC BY 4.0** license.
- See [LICENSE](LICENSE) for the license text.

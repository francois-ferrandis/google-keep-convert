# google-keep-convert

Convert your Google Keep notes from a Google Takeout archive.

## Import Google Keep Archive within Joplin

This script:

- creates a new notebook called "Google Keep Import #{Time.now}"
- imports **title**, **body** and **timestamp** (Google keep only has "updated_at" data)
- Converts "list type" notes to Markdown with a list of checked/unchecked items
- ensures that there is a note title by defaulting to the body's first line, truncated

```sh
ruby import_keep_notes_into_joplin.rb --input-dir path/to/takeout_json_files --joplin-token $joplin-web-clipper-token$
```

## Convert Google Keep notes to Nextcloud Notes files (markdown)

This script:

- creates a .txt file for each Google Keep note
- uses the note's timestamp to `touch` each .txt file, so Nexcloud displays them in order
- converts "list type" notes to Markdown with a list of checked/unchecked items
- ensures that there is a note title by defaulting to the body's first line, truncated

```sh
ruby create_nextcloud_notes.rb --input-dir path/to/takeout_json_files --output-dir output_dir
```

Note: Usage of theNexcloud official file sync client is recommended to preserve
files timestamps. From my experience, WebDAV does not preserve timestamps.

# Contributing

This is a small project that I made for my personal needs,
so the features and tests are incomplete.

Pull requests welcome!

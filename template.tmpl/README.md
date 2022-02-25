{{ if file.Exists "README.md" }}{{- file.Read "README.md" -}}{{ else -}}
# `command`

Your project's description
{{ end -}}

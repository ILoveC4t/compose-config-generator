# config-generator

Simple container I use to generate configs for my other setups.

## Workflow
- Reads all files matching `*.template` from `TEMPLATES_DIR` (default `/templates`).
- Fills in environment variables with the syntax `${VAR}`.
- Writes results to `OUTPUT_DIR` (default `/output`) with the `.template` at the end removed.

## Use
- Build: `./build.sh`
- Run:
  - `docker run --rm -v ./templates:/templates:ro -v ./output:/output \`
    `-e DOMAIN=example.com config-generator:latest`

## Env vars
- TEMPLATES_DIR: directory with templates (default `/templates`)
- OUTPUT_DIR: directory for generated files (default `/output`)
- TEMPLATE_PATTERN: glob for templates (default `*.template`)
- DEBUG: if `true`, prints a short preview of each generated file (default `false`)
- KEEP_RUNNING: if `true`, keeps the container alive after generation (default `false`)

## Examples
- Check `examples/docker-compose.yml` for basic usage.
- Example templates in `examples/templates/` (nginx.conf.template, Caddyfile.template).
- Generated files are placed in `examples/output/` when you run the example.
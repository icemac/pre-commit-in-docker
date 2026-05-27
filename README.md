# pre-commit-in-docker

Run [pre-commit](https://pre-commit.com/) inside a Docker container instead of
installing it locally. Hooks are not baked into the image -- they are downloaded
at runtime from each project's `.pre-commit-config.yaml` and cached in a named
Docker volume so they persist across runs and projects.

## Build

```bash
make build
```

## Usage

### Run manually against all files

From any project directory that contains a `.pre-commit-config.yaml`:

```bash
docker run --rm \
  -v "$(pwd):/src" \
  -v pre-commit-cache:/root/.cache/pre-commit \
  -w /src \
  pre-commit run --all-files
```

Or using the Makefile (run from the project directory or copy the Makefile
there):

```bash
make -f /path/to/this/Makefile run
```

### Use as a git hook

To have this run automatically on every commit, create
`.git/hooks/pre-commit` in your repository:

```bash
#!/usr/bin/env bash
FILES=$(git diff --cached --name-only --diff-filter=ACMR -z | tr '\0' ' ')
if [ -n "$FILES" ]; then
  docker run --rm \
    -v "$(pwd):/src" \
    -v pre-commit-cache:/root/.cache/pre-commit \
    -w /src \
    pre-commit run --hook-stage commit --files $FILES
fi
```

Make it executable:

```bash
chmod +x .git/hooks/pre-commit
```

### Apply to all repositories via a global git template

```bash
mkdir -p ~/.git-templates/hooks
# copy the hook script above to ~/.git-templates/hooks/pre-commit
chmod +x ~/.git-templates/hooks/pre-commit
git config --global init.templateDir ~/.git-templates
```

Every new `git init` or `git clone` will pick up the hook automatically. For
existing repos, run `git init` again to apply the template.

### Debug shell

To open an interactive shell inside the container (useful for troubleshooting):

```bash
make shell
```

## Cleanup

Remove the image and the hook cache volume:

```bash
make clean
```

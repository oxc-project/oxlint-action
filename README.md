# oxlint-action

Run [Oxlint](https://github.com/oxc-project/oxc) on your project.

## Quick Start

```yaml
# .github/workflows/ci.yml
name: CI
on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize]
    paths_ignore:
      - "*.md"
      - "*.json"
  push:
    branches:
      - main
    paths_ignore:
      - "*.md"
      - "*.json"

jobs:
  lint:
    name: Lint (Oxlint)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DonIsaac/oxlint-action@latest
        with:
          # Allow, Warn, or Deny specific lint rules or entire categories
          # https://oxc.rs/docs/guide/usage/linter/cli.html#enable-plugins
          deny: |
            correctness
            no-eval
          warn: |
            suspicious
            perf
          # https://oxc.rs/docs/guide/usage/linter/cli.html#enable-plugins
          plugins: nextjs jest

```

## Example

```yaml
name: Lint
on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: DonIsaac/oxlint-action@latest
      with:
        # Specify an Oxlint config file if you already have one. Oxlint is also
        # compatible with JSON ESLint configs (v8 and lower).
        # https://oxc.rs/docs/guide/usage/linter/config.html
        config: .oxlintrc.json

        # allow/warn/deny all take a whitespace separate list of categories or
        # rules to allow, warn or deny. By default, only violations for rules in
        # the "correctness" category be warned.
        # See https://oxc.rs/docs/guide/usage/linter/cli.html#allowing-denying-multiple-lints
        # for a list of categories and rules.
        allow: |
          no-namespace
          for-direction          
        warn: |
          correctness
          suspicious
        deny: |
          no-const-assign
          no-constant-condition

        # Plugins to enable or disable. Separate each plugin with whitespace,
        # and only provide the plugin name.
        # See https://oxc.rs/docs/guide/usage/linter/cli.html#enable-plugins for
        # more information
        plugins: nextjs import
        plugins-disable: react

        # By default, oxlint-action will only lint changed files when run on
        # pull requests. To disable this behavior, set this to false.
        # Note that this setting has no affect on any other kind of trigger.
        all-files: false

        # Explicitly specify the base branch that PRs will be compared against.
        # By default the branch the PR is attempting to merge into will be used.
        # Has no affect on any other kind of trigger.
        base-branch: main

        # Use a specific version of Oxlint. You can also specify a SemVer
        # pattern. This gets forwarded to npx. By default, 'latest' is used.
        # See: https://www.npmjs.com/package/oxlint
        version: latest
```

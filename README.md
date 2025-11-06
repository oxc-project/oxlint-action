<p align="center">
  <img alt="OXC Logo" src="https://cdn.jsdelivr.net/gh/oxc-project/oxc-assets/square-bubbles.svg" width="200">
</p>

<div align="center">

[![OXC Stars][oxc-stars-badge]][oxc-github-url]
[![Website][website-badge]][website-url]
[![CI](https://github.com/oxc-project/oxlint-action/actions/workflows/ci.yml/badge.svg)](https://github.com/oxc-project/oxlint-action/actions/workflows/ci.yml)
[![npm][npm-badge]][npm-url]
[![Discord chat][discord-badge]][discord-url]

</div>

## ⚓ Run [Oxlint][oxc-github-url] on your repo

This action lints your JS/TS codebase with
[Oxlint][oxc-github-url] and attaches reported issues as
annotations. Pull requests will only have their changed files linted by default.

For monorepos, you can use the `working-directory` input to lint only a specific subdirectory.


## ⚡ Quick Start
Here's a minimal example to get you started:
```yaml
# .github/workflows/ci.yml
name: CI
on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize]
    paths-ignore:
      - "*.md"
      - "*.json"
  push:
    branches:
      - main
    paths-ignore:
      - "*.md"
      - "*.json"

jobs:
  lint:
    name: Lint (Oxlint)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: oxc-project/oxlint-action@v2.0.1
        with:
          # Allow, Warn, or Deny specific lint rules or entire categories
          # https://oxc.rs/docs/guide/usage/linter/cli.html#allowing-denying-multiple-lints
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
Here's a more complete example with all available options:
```yaml
name: Lint
on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: oxc-project/oxlint-action@latest
      with:
        # Specify an Oxlint config file if you already have one. Oxlint is also
        # compatible with JSON ESLint configs (v8 and lower).
        # https://oxc.rs/docs/guide/usage/linter/config.html
        config: .oxlintrc.json

        # allow/warn/deny all take a whitespace separate list of categories or
        # rules to allow, warn or deny. If not specified, oxlint will use the
        # configuration from your config file, or oxlint's defaults.
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

        # Specify a working directory to run oxlint in. Useful for monorepos
        # where you want to lint only a specific subdirectory.
        working-directory: frontend
```

[oxc-stars-badge]: https://img.shields.io/github/stars/oxc-project/oxc?style=social
[oxc-github-url]: https://github.com/oxc-project/oxc
[npm-badge]: https://img.shields.io/npm/v/oxlint/latest?color=brightgreen
[npm-url]: https://www.npmjs.com/package/oxlint/v/latest
[website-badge]: https://img.shields.io/badge/Website-blue
[website-url]: https://oxc.rs
[discord-badge]: https://img.shields.io/discord/1079625926024900739?logo=discord&label=Discord
[discord-url]: https://discord.gg/9uXCAwqQZW

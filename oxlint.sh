#!/bin/bash

set -e -o pipefail

# config
if [ -n "$OXLINT_CONFIG" ]; then
    # check if config file exists
    if [ ! -f "$OXLINT_CONFIG" ]; then
        echo "::error file={$OXLINT_CONFIG}::Config file not found: $OXLINT_CONFIG"
        exit 1
        
        # check if the config file is js, which is not supported
        elif [ "${OXLINT_CONFIG##*.}" = "js" ]; then
        echo "::error file={$OXLINT_CONFIG}::Oxlint only supports JSON files. Please convert your config file to JSON."
        exit 1
    fi
    
    config="--config $OXLINT_CONFIG"
fi

OXLINT_ARGS="$config"

# Build plugin args
# map whitespace-separated `name` to `--name-plugin`
if [ -n "$OXLINT_PLUGINS" ]; then
    plugins="$(echo "$OXLINT_PLUGINS" | xargs | sed -e 's/ / --/g' -e 's/^/--/')-plugin"
fi

# build disable plugin args
# map whitespace-separated `name` to `--disable-name-plugin`
if [ -n "$OXLINT_PLUGINS_DISABLE" ]; then
    disable_plugins="$(echo "$OXLINT_PLUGINS_DISABLE" | xargs | sed -e 's/ / --disable-/g' -e 's/^/--disable/')-plugin"
fi

OXLINT_ARGS="$OXLINT_ARGS $plugins $disable_plugins"

# build allow, warn, and deny lists
# map `rule-name` to `-[A/W/D] rule-name`
if [ -n "$OXLINT_ALLOW" ]; then
    allow_list="$(echo "$OXLINT_ALLOW" | xargs | sed -e 's/ / -A /g' -e 's/^/-A /')"
fi

if [ -n "$OXLINT_WARN" ]; then
    warn_list="$(echo "$OXLINT_WARN" | xargs | sed -e 's/ / -W /g' -e 's/^/-W /')"
else
    warn_list="-W correctness"
fi

if [ -n "$OXLINT_DENY" ]; then
    deny_list="$(echo "$OXLINT_DENY" | xargs | sed -e 's/ / -D /g' -e 's/^/-D /')"
fi

# order is important. We want consumers to be able to deny a category, and then
# allow single rules as needed.
OXLINT_ARGS="$OXLINT_ARGS $warn_list $deny_list $allow_list"

# build deny warnings and max warnings args
if [ -n "$OXLINT_MAX_WARNINGS" ]; then
    OXLINT_ARGS="$OXLINT_ARGS --max-warnings $OXLINT_MAX_WARNINGS"
fi

if [ "$OXLINT_DENY_WARNINGS" = "true" ]; then
    OXLINT_ARGS="$OXLINT_ARGS --deny-warnings"
fi

# use github output format
OXLINT_ARGS="$OXLINT_ARGS --format github"

echo "::debug::Args: $OXLINT_ARGS"


# Files to lint are passed as arguments. For non-prs, no arguments are passed,
# which defaults to all VCS files.
# shellcheck disable=SC2068,SC2086
npx oxlint@$OXLINT_VERSION $OXLINT_ARGS ${@:1}

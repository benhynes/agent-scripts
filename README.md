# agent-scripts

A tiny **setup** for keeping your personal/agent helper scripts in one place,
on your PATH, runnable by name from anywhere.

This repo is the *scaffold*, not the scripts. It gives you:

- a `~/.scripts/bin` directory for **your own** scripts (kept private/local),
- an `install.sh` that creates it and adds it to your PATH idempotently,
- an example showing the recommended way to handle secrets in a script.

The idea: clone this, run the installer, then drop your scripts into
`~/.scripts/bin`. Your actual scripts never live in this repo — only the setup
does, so the repo can be shared publicly without leaking anything machine-specific.

## Install

```bash
git clone https://github.com/benhynes/agent-scripts.git
cd agent-scripts
./install.sh          # creates ~/.scripts/bin, adds it to PATH, installs examples
exec $SHELL           # reload your shell
```

Then any executable you put in `~/.scripts/bin` runs by name:

```bash
cp my-tool ~/.scripts/bin/ && chmod +x ~/.scripts/bin/my-tool
my-tool        # works from anywhere
```

## Discovering what's installed (`agent-scripts`)

The installer drops an `agent-scripts` command into `~/.scripts/bin`. It's a
**self-maintaining registry**: it scans your scripts directory and reads a
one-line description from each script's header — nothing to keep in sync by hand.

```bash
agent-scripts list          # human-readable table of installed scripts
agent-scripts json          # machine-readable manifest (for agents/automation)
agent-scripts show NAME     # full header/usage for one script
agent-scripts path          # print the scripts bin directory
```

This is handy for **agents**: at the start of a session, an agent can run
`agent-scripts json` to discover exactly which helper scripts exist on the
machine, instead of guessing or relying on stale notes.

### Description convention

Give each script a one-line description in its header (first ~15 lines). Any of:

```bash
# my-tool — what it does          # shell scripts (em dash or hyphen)
```
```python
"""my-tool — what it does."""     # python scripts (module docstring)
```
```
# description: what it does       # explicit form, any language
```

Otherwise the first comment line is used. Set `AGENT_SCRIPTS_PATH` (colon-
separated) to also scan directories outside `~/.scripts/bin`.

## Secrets pattern

Scripts that need API keys should **not** hardcode them. Store keys once in the
macOS Keychain with [agent-secret](https://github.com/benhynes/agent-secret),
then fetch at runtime:

```bash
API_KEY="$(agent-secret get SOME_API_KEY)"          # inline
agent-secret run SOME_API_KEY=API_KEY -- some-tool  # inject as env, never on disk
```

See [`examples/example-api-call`](examples/example-api-call) for the full pattern.

## Why a separate ~/.scripts (not this repo) holds your scripts

Develop/version the *setup* here; keep your real scripts in `~/.scripts/bin`,
which is local and private. That way machine-specific paths, assumptions, and
one-off tools never get committed to a public repo. Cherry-pick any script
that's genuinely reusable into its own dedicated repo when it's worth sharing.

## License

MIT — see [LICENSE](LICENSE).

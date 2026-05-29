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

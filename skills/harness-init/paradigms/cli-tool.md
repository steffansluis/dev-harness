# Paradigm: cli-tool

A command-line tool invoked in a terminal. Produces text output to stdout/stderr;
has no graphical UI and typically targets a single locale (English). Focuses on
argument parsing correctness, exit codes, and README accuracy for discoverability.

## Use When

- The project is invoked from the command line (e.g. `mytool --flag value`)
- Output is plain text, structured text (JSON/YAML), or binary to stdout
- There is no visual UI, no browser rendering, and no localisation requirement
- The primary user-facing surface is the README / `--help` output

---

## Enabled Gates

| Gate | Enabled | Reason |
|------|---------|--------|
| design | no | CLI interface design is captured in README / --help spec, not mockups |
| readme | yes | Argument changes, new flags, and new commands must be documented |
| acceptance | yes | CLI behaviour is best verified by running the tool end-to-end in a test shell |
| screenshots | no | No graphical UI — visual screenshots are not applicable |
| i18n | no | CLI tools typically target English; output strings are developer-facing |

---

## Stack Notes

Typical stacks: Node/TypeScript (oclif, commander), Go (cobra), Python (click, argparse), Rust (clap).
Test runner: shell-based acceptance tests (bats, shunit2) or language-native integration tests.
CI: acceptance tests run on push to main / PR open (remote).

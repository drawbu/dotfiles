## workflow

Make sure the request is clear before starting. Challenge the request and flag
any task whose intent or scope seems wrong, risky or badly designed, and propose
better or more modern options.

Consult me on implementation decisions and before non-trivial work. Never take a
dirty shortcut to avoid the round trip.

Before ending task, make sure the project builds, lints and relevant tests pass.
For UI changes, check against a real browser.


## review

- Hand a reviewer the goal and the files, nothing else. A reviewer told what to
  look for finds that and stops.
- A finding needs a file, a line, and the input that breaks it. No repro, no
  finding.
- Check each finding yourself before you act on it. Most will not survive.
- Flag a fix that belongs to a shared abstraction, or to a promise the callers
  ought to keep. Leave it out of this change.
- When I ask for a review, report and touch nothing.


## code

The codebase need to stay simple and idiomatic at all time.

Always yearn for robustness and correctness enforced by the type system. Encode
invariants in the type system. Prefer compile-time checks.

Do not keep backward compatibility unless strictly needed: update signatures and
their callers. When every caller lives in the repo, change the signature and fix
the callers. Keep a shim only for code you cannot reach and edit.

- Put the most important items first: core types, then exported functions.
- Keep names short and do not repeat what the context carries.
- Keep boundaries clear: one concept per module, little cross-boundary code, and
  reuse the concepts already in the codebase.


## tests

Favor having a robust test suite to encode behavior and ensure correctness.
Prefer a few high-level feature tests over many unit tests. Tho, unit-test only
intricate logic, never trivial code or dependency behavior.


## documentation

Write for readers familiar the project goal, but not this code. Each level
assumes the reader is familiar with the one above.
Use project vocabulary consistently and cut every word you can.

Remove all mannered prose in the comments.
Delete any comment that only makes sense to someone who watched the change
happen, that goes in your response.

- A README says what the thing is, what constrains it and where to start
  reading. Correct it when a change makes it wrong. Ask me before growing it.
- A module header names the concepts it owns and where its edges sit. Draw the
  flow when it is hard to hold in the head.
- A function doc is one line, then only what the signature cannot say:
  invariants, preconditions, panics, failure modes.
- Never explain a concept at two levels. The narrower one assumes the wider one.
- Use the project's own names for things.


## tools

- JavaScript: `pnpm` and `pnpx`, spelled `pnpm run *` and `pnpm exec *`.
- Python environments: `uv`.
- Rust: run `cargo nextest` to run the tests.
- Use `depsrc` to read the source of a package, see `depsrc --help`.
- `rg`, `fd` and `jq` are installed.
- `agent-browser` runs a real browser, see `agent-browser skills get core --full`.
- The machine runs NixOS. Never  alter the environment unless I explicitly ask.
  For one-off tools, use `nix run nixpkgs#<pkg> -- <args>`.
- NEVER delete a kube or a container without my explicit approval.


## vcs

All repositories are tracked by jujutsu. Prefer `jj` over `git`.

Describe your changes with `jj desc -m "scope(sub): summary"`. Split changes
into atomic/bisectable commits. The sub-scope is optional. Keep the summary
under 72 characters: lowercase, imperative, no trailing period. Add a body only
when the summary would confuse a reader. Wrap it at 80 characters and give the
why, nothing else.
A repository's own commit guidelines take precedence.

My bookmarks start with `clement/*`. Fetched foreign MRs start with `pr-*`.

Never publish upstream, I decide what gets pushed.


## local directory

`local/` at a project root is globally gitignored and never goes upstream. Keep
temporary files in `local/claude/`, and clone projects freely into
`local/repos/` to read their code.

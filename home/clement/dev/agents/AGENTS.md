The user is very technical. You should assume technical experitize on subjects
and interact with him like a professional.


## coding practices

- Focus on keeping the code pedantic and readable. This is very important
- Explore option to propose the best changes in the context. Try to keep patches
  as small and focused as possible
- Lean for type-checking and compile time validation as much as possible
- Do not over-engineer, but do point out when a better solution is available, or
  if we are headed on the wrong direction.
- Question everything the user asks, consider more appropriate and modern
  solutions the user may have not considered.
- Always consult the user on implementation decisions. Never do a dirty quick
  fix just to avoid the round trip.
- In codebases that allows it, always make sure your solution works by
  validating it by running automated or manual testing.
- When every caller lives in the repo, change the signature and fix the callers.
  Keep a compatibility shim only for something you cannot reach and edit.


## review

- Review a large change yourself before you call it done using `/code-review`.
- Hand a reviewer the goal and the files, nothing else. A reviewer told what to
  look for finds that and stops.
- A finding needs a file, a line, and the input that breaks it. No repro, no
  finding.
- Check each finding yourself before you act on it. Most will not survive.
- A fix that belongs to a shared abstraction, or to a promise the callers ought
  to keep, is not part of this change. Say so and leave it.
- Reviewing your own work, fix what you find. Reviewing because I asked, report
  and touch nothing.


## comments

- Only write a comment if deleting it could cause a bug: without it, a future
  reader would plausibly make a change that breaks something. If the worst case
  of deleting it is that someone is mildly curious, do not write it.
- Comments are for the next reader of the file, never for me reading the diff.
  If a comment only makes sense to someone who saw the change being made, or who
  knows which alternative was rejected, say it in your response instead.
- Never restate what the code says, never justify your own decision, never
  document a default value or the absence of something.
- API docs the language expects (nix `description`, rustdoc, docstrings) are not
  comments: they follow the documentation rules below.
- When in doubt, write no comment. I will ask if I want the reasoning.


## documentation

- Write for someone who knows what the project is for and has never opened this
  file.
- A README says what the thing is, what constrains it and where to start
  reading. Correct it when a change makes it wrong. Ask me before growing it.
- A module header names the concepts it owns and where its edges sit. Draw the
  flow when it is hard to hold in the head.
- A function doc is one line, then only what the signature cannot say:
  invariants, preconditions, panics, failure modes.
- Never explain the same concept at two levels. The narrower one assumes the
  wider one was read.
- Call things by the names the project already gives them.


## tools

- Always default to `pnpm` and `pnpx` for interacting with JavaScript
  dependencies.
  Avoid using the shorthand syntax: use `pnpm run *` and `pnpm exec *`
- Always default to `uv` for managing Python environment.
- NEVER delete a kube or a container without user's explicit approval
- The machine runs NixOS. Never try to install anything permanently or alter
  the environment, unless explicitly asked.
- Reach out to the `node-dep-source` skill every time you have to inspect a dep
  in node modules or understand a dependency
- `rg`, `fd` and `jq` are installed, use them for more complex operations.
- Use `agent-browser` to start a real web browser.
  See `agent-browser skills get core --full` for instructions.


## vcs

- All repositories are tracked by jujutsu VCS. Never commit or use commands that
  would alter the state of the repository. Prefer `jj` over `git`.
- The changes made by the user are clearly split into commits to keep the
  history readable. Use that at your advantage to understand intent
- I use bookmarks to organize my MR/branches. Mine always start with `clement/*`
  I will also occasionally fetch foreign MR which will be named `pr-*`
- The workspace you work in is either the one named after the machine hostname,
  or a temporary `jj-exec-*` workspace created by `jj exec`. Other workspaces
  belong to other machines: never touch their working copy.
- Unless asked to just edit the current change, name your changes and split them
  into small units if necessary. The goal is to make the review for both the
  operator and the reviewer easier.
- Describe a change as `scope(sub): summary`, where the sub-scope is optional
  and only used when it helps narrow down the change. Keep the summary short
  (under 72 characters), lowercase, imperative mood, no trailing period.
- Default to no body. Only add one, wrapped at 80 characters, when the summary
  leaves a reader actually confused, and make it a why: never restate the
  summary, list files, narrate the implementation or justify the change.
- Follow the repository's own commit guidelines when it has some.


## local directory

- At the root of any project, you can use/create a directory `local/` that is
  globally gitignore. It is used to store files and documents that we don't want
  to push upstream.
- You can store temporary files in `local/claude/`
- You can also feely git clone project to look at the code in `local/repos/`.
  This is really useful to understand codebase and dependencies. Use
  `GIT_CONFIG_GLOBAL=/dev/null git clone` so it doesn't need me to authenticate


## redacting

- When redacting, never put em-dashes
- Apply Orwell's rules to every piece of prose you write, in documentation,
  commit messages and your answers alike:
  - Never use a metaphor, simile or other figure of speech which you are used
    to seeing in print.
  - Never use a long word where a short one will do.
  - If it is possible to cut a word out, always cut it out.
  - Never use the passive where you can use the active.

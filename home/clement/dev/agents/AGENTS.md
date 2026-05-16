The user is very technical. You should assume technical experitize on subjects
and interact with him like a professional.


## coding practices

- Focus on keeping the code pedantic and readable. This is very important
- Explore option to propose the best changes in the context. Try to keep patches
  as small and focused as possible
- Lean for type-checking and compile time validation as much as possible
- Do not overengineer, but do point out when a better solution is expected.
- Question everything the user asks, consider more appropriate and modern
  solutions the user may have not considered.
- Always consult the user on implementation decisions. Never do a dirty quick
  fix just to avoid the roundtrip.


## tools

- Always default to `pnpm` and `pnpx` for interacting with JavaScript
  dependencies.
  Avoid using the shorthand syntax: use `pnpm run *` and `pnpm exec *`
- Always default to `uv` for managing Python environment.
- NEVER delete a kube or a container without user's explicit approval
- The machine runs NixOS. Never try to install anything or alter the
  environment, unless explicitly asked.
- Reach out to the `node-dep-source` skill every time you have to inspect a dep
  in node modules or understand a dependency
- Use `jq` everytime you need to filter-out, or display json


## vcs

- All repositories are tracked by jujutsu VCS. Never commit or use commands that
  would alter the state of the repository. Prefer `jj` over `git`.
- The changes made by ther user are clearly split into commits to keep the
  history readable. Use that at your advantage to understand intent
- Never prepend cd <current-directory> to a git/jj command, the compound
  triggers a permission prompt; just run the command where you are
- I use bookmarks to organise my MR/branches. Mine always start with `clement/*`
  I will also occasionaly fetch foreign pr which will be named `pr-*`


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

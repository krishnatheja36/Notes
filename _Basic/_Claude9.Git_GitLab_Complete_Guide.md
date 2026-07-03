# Git & GitLab Complete Guide for Data Engineers

Practical Git + GitLab reference for daily data-engineering work.

---

## Git Fundamentals

**Three areas:** Working Directory (your files) → Staging Area (`git add`) → Repository (`git commit`).

**Key terms:**
- **Commit** — snapshot of changes (what, who, when, message)
- **Branch** — independent line of development
- **Main/Master** — production-ready branch
- **Remote** — server copy of the repo (GitLab/GitHub)
- **Merge Request (MR)** — request to merge a branch, requires review

**Git** = the CLI tool. **GitLab** = the hosting/collaboration platform (like GitHub).

---

## Setup

```bash
brew install git              # Mac
sudo apt-get install git      # Ubuntu/Linux

git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git config --global --list    # Verify
```

---

## Daily Workflow

```bash
git clone https://gitlab.company.com/data-eng/my_pipeline.git
cd my_pipeline

git status                    # see changed/staged/untracked files
git add pipeline.py           # stage a file (or git add . for all)
git commit -m "fix: handle null values in pyspark pipeline"
git push                      # send commits to GitLab
```

**Commit message style:** start with a verb (`fix`, `add`, `refactor`, `update`), lowercase, short, explain *why* not *what*.
- Good: `fix: prevent divide-by-zero in aggregation`
- Bad: `fixed stuff`, `updates`, `wip`

---

## Branching & Merging

```bash
git checkout -b feature/handle-nulls   # create + switch
git switch -c feature/handle-nulls     # modern equivalent
git branch -a                          # list all branches
git push origin feature/handle-nulls   # push branch
```

**Naming convention:** `feature/`, `bugfix/`, `hotfix/`, `refactor/`, `docs/`.

**Never merge directly into `main` — always open a Merge Request**, so the team can review before it lands.

**MR flow:** push branch → GitLab → New Merge Request → select source/target branch → fill title/description → request review → reviewer comments/approves → click Merge.

**Conflicts:**
```bash
git merge feature/other-feature
# CONFLICT (content): Merge conflict in pipeline.py
```
Open the file, resolve `<<<<<<< / ======= / >>>>>>>` markers, then:
```bash
git add pipeline.py
git commit -m "resolve: merge conflict in pipeline.py"
```
Easier to resolve visually in VS Code/PyCharm.

---

## Rebase vs Merge

**Rebase** replays your commits on top of the latest `main` → linear, clean history.
**Merge** creates a merge commit → shows where branches came together.

```bash
git fetch origin
git rebase origin/main          # replay your commits on top
# fix conflicts if any:
git add conflicted_file.py
git rebase --continue           # or: git rebase --abort

git push --force-with-lease     # required after rebase (NOT --force)
```

Interactive rebase (reorder/squash/edit commits):
```bash
git rebase -i HEAD~3
# pick / reword / squash / drop
```

| Strategy | History | Use for |
|---|---|---|
| `git merge` | Merge commit | `main`, shared branches |
| `git rebase` | Linear | Feature branches, before MR |

**Most teams: rebase feature branches, merge into main.**

---

## Undoing Changes

```bash
git restore pipeline.py             # discard unstaged changes
git restore --staged pipeline.py    # unstage
git reset --soft HEAD~1             # undo last commit, keep changes
git reset --hard HEAD~1             # undo last commit, discard changes (dangerous)
git revert abc1234                  # new commit that undoes an old one (safe)
```

**Reset vs Revert:**

| Scenario | Use |
|---|---|
| Committed locally, not pushed | `reset` |
| Pushed/merged to main | `revert` |
| Want to erase history | `reset` |
| Want to preserve history | `revert` |

If you pushed a mistake but haven't merged yet: `git reset --soft HEAD~1`, fix, recommit, `git push --force-with-lease`.

---

## Sparse Checkout (Partial Clone)

Use when a repo is huge (100+ GB) and you only need one team's folder.

```bash
git init my-project && cd my-project
git remote add origin https://gitlab.company.com/project.git
git config core.sparseCheckout true

cat >> .git/info/sparse-checkout << EOF
data-pipelines/
config/
utils/
EOF

git pull origin main
```

Add more folders later: append to `.git/info/sparse-checkout`, then `git pull` again. Full history still downloads — only the checked-out files are limited. Requires Git 2.25+.

---

## GitLab-Specific Features

**MR templates** — `.gitlab/merge_request_templates/default.md` autofills new MR descriptions (what/why/testing/checklist).

**CI/CD (`.gitlab-ci.yml`)** — runs automatically on push:
```yaml
stages: [test, deploy]
test_pipeline:
  stage: test
  script:
    - python -m pytest tests/
    - pylint pipeline.py
deploy:
  stage: deploy
  script: echo "Deploying to production"
```
Failing pipeline = red X on your MR.

**Protected branches** — `main` typically can't be pushed to directly; requires MR + passing pipeline + resolved discussions.

---

## Git Workflows (Branching Strategies)

| Workflow | Branches | Releases | Complexity | Best for |
|---|---|---|---|---|
| GitHub Flow | main + features | Continuous | Low | Startups, data eng |
| Git Flow | main + develop + release/hotfix | Scheduled | High | Enterprise, mobile |
| GitLab Flow | main + features + env branches (staging/prod) | Continuous | Medium | Data pipelines, hybrid teams |

Most data engineering teams use **GitHub Flow** or **GitLab Flow**. Ask your team which one they use.

---

## Best Practices

**Do:**
- Commit often, in small logical chunks
- Push daily — don't hoard commits locally
- Write commit messages that explain *why*
- Review your own MR before requesting review
- Delete branches after merging
- Pull before you push

**Don't:**
- Commit huge, hard-to-review changes — split into multiple MRs
- Push directly to `main`
- Use `git push --force` (use `--force-with-lease`)
- Commit secrets (`.env`, API keys) — use `.gitignore`; if leaked, `git rm --cached <file>`
- Leave stale branches around for weeks
- Skip code review

---

## .gitignore

```bash
# Python
__pycache__/
*.pyc
.pytest_cache/
.venv/

# IDE / OS
.vscode/
.idea/
.DS_Store

# Data (too big to version)
*.csv
*.parquet
data/

# Secrets — never commit
.env
secrets.json
*_keys.txt
```

Must be committed itself, so the whole team uses it:
```bash
git add .gitignore
git commit -m "add: gitignore"
```

---

## Advanced

```bash
git stash                          # save uncommitted work, clean working dir
git stash pop                      # restore + remove stash
git cherry-pick a1b2c3d            # apply one commit from another branch
git tag -a v1.0.0 -m "Release"     # annotated tag
git push origin --tags
git worktree add ../feature-branch feature/my-feature   # work on 2 branches at once
```

**Squash commits before merging** (clean history, easier revert):
```bash
git rebase -i HEAD~3
# mark extras as 'squash'
```
Or enable "squash on merge" in the GitLab MR settings.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Committed something wrong (not pushed) | `git reset --soft HEAD~1`, fix, recommit |
| Pushed something broken, not merged | `git reset --soft HEAD~1` → fix → `git push --force-with-lease` |
| Pushed and already merged to main | `git revert HEAD && git push` |
| Lost a commit | `git reflog` → `git reset --hard <hash>` |
| On the wrong branch | `git stash` → `git checkout correct-branch` → `git stash pop` |
| Merge conflict | Open file, resolve `<<<`/`>>>` markers, `git add`, `git commit` |

---

## Git Commands Cheat Sheet (Reference)

### Setup
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git config --global core.editor "code"   # Set default editor (VS Code)
git config --list                        # View all configs
```

### Clone & Create
```bash
git clone https://gitlab.company.com/repo.git
git clone https://gitlab.company.com/repo.git my-folder  # Clone into specific folder
git init                      # Start new repo
```

### Branches
```bash
git branch                    # List branches
git branch -a                 # All branches (local + remote)
git branch -r                 # Remote branches only
git checkout -b feature/name  # Create and switch
git switch feature/name       # Switch (modern)
git switch -c feature/name    # Create and switch (modern)
git branch -m old-name new-name  # Rename branch
git branch -d feature/name    # Delete local (safe, only if merged)
git branch -D feature/name    # Force delete local (even if unmerged)
git push origin --delete feature/name  # Delete remote
```

### Staging & Committing
```bash
git status                    # See what changed
git add .                     # Stage all
git add file.py                # Stage specific file
git add *.py                   # Stage all files matching a pattern
git add -A                     # Stage all changes (new, modified, deleted)
git add -p                     # Interactive staging
git commit -m "message"       # Commit
git commit -am "message"       # Stage tracked files + commit in one step
git commit --amend -m "msg"    # Amend last commit (message or forgotten files)
git reset file.py              # Unstage specific file
git reset                      # Unstage everything
```

### Remotes
```bash
git remote -v                          # View remotes
git remote add origin <url>            # Add a remote
git remote remove origin               # Remove a remote
git remote rename old-name new-name    # Rename a remote
git remote add upstream <url>          # Add upstream (for forks)
```

### Pushing & Pulling
```bash
git push origin main         # Push to remote
git push -u origin main      # Set upstream and push
git push --all               # Push all branches
git pull origin main         # Pull from remote
git fetch origin             # Get updates (no merge)
git fetch upstream            # Fetch from upstream (fork workflow)
git merge origin/main        # Merge remote into local
```

### Viewing History
```bash
git log --oneline            # Recent commits
git log --oneline -5         # Last 5 commits
git log --graph --all        # Visual history
git log -p                    # Show full diff per commit
git log --author="Name"       # Filter by author
git log --since="2 weeks ago" # Filter by date
git log --grep="bug fix"      # Search commit messages
git log -S "function_name"    # Search for code changes (pickaxe)
git show abc1234             # Details of commit
git show --name-only abc1234  # Only files changed, no diff
git diff                     # Show unstaged changes
git diff --staged             # Show staged changes
git diff commit1 commit2      # Diff between two commits
git diff branch1 branch2      # Diff between two branches
git blame file.py            # Who changed each line
```

### Undo
```bash
git checkout file.py         # Discard changes
git reset HEAD~1 --soft      # Undo commit, keep changes
git reset HEAD~1 --hard      # Undo commit, discard changes
git reset --soft <commit>     # Reset to a specific commit, keep changes staged
git reset --hard <commit>     # Reset to a specific commit, discard changes (dangerous)
git revert abc1234           # Create undo commit
```

### Stash (Temporary Save)
```bash
git stash                    # Save work
git stash save "message"      # Save work with a description
git stash pop                # Restore work and remove stash
git stash apply               # Restore work, keep stash
git stash apply stash@{2}     # Apply a specific (non-latest) stash
git stash list               # See all stashes
git stash drop stash@{0}      # Delete a specific stash
git stash clear               # Delete all stashes
```

### Tagging
```bash
git tag                       # List tags
git tag v1.0.0                 # Create lightweight tag
git tag -a v1.0.0 -m "msg"      # Create annotated tag
git tag v1.0.0 <commit-hash>    # Tag a specific commit
git push origin v1.0.0          # Push one tag
git push --tags                 # Push all tags
git tag -d v1.0.0                # Delete local tag
git push origin --delete v1.0.0  # Delete remote tag
```

### Cleaning Untracked Files
```bash
git clean -n                  # Dry run — show what would be deleted
git clean -f                  # Delete untracked files
git clean -fd                 # Delete untracked files and directories
```

### Aliases (Shortcuts)
```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --graph --oneline --all'
```

### Recovering Lost Work
```bash
git reflog                              # Find lost commits/branches
git reset --hard abc1234                # Restore to a found commit
git checkout -b branch-name commit-hash # Recover a deleted branch
```

---

## GitLab Quick Reference

- **View code:** Project → Repository → Files
- **Create MR:** Push branch → "Create Merge Request" button
- **Review:** MR → Changes tab → click line to comment
- **Merge:** MR → "Merge" button (after approval)
- **Pipeline status:** MR → Pipeline tab

---

## Resources

- Interactive Tutorial: https://learngitbranching.js.org/
- Official Git Docs: https://git-scm.com/doc
- Atlassian Guide: https://www.atlassian.com/git/tutorials
- GitLab Docs: https://docs.gitlab.com/

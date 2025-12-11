# Materi Pembelajaran: Git Version Control Fundamentals

> **Workflow**: `/02-git-basics`  
> **Durasi**: 3-4 jam  
> **Level**: Beginner to Intermediate  
> **Prerequisites**: Linux environment sudah setup

---

## 📚 Daftar Isi

1. [Pengenalan Version Control](#pengenalan-version-control)
2. [Git Fundamentals](#git-fundamentals)
3. [Git Workflow](#git-workflow)
4. [Branching & Merging](#branching-merging)
5. [Remote Repositories](#remote-repositories)
6. [Conventional Commits](#conventional-commits)
7. [Advanced Git](#advanced-git)
8. [Hands-On Exercises](#exercises)
9. [Troubleshooting](#troubleshooting)

---

## 1. Pengenalan Version Control

### Apa itu Version Control?

**Version Control System (VCS)** adalah tools untuk:
- Track perubahan code over time
- Collaborate dengan tim
- Rollback ke versi sebelumnya
- Branching untuk fitur baru

### Mengapa Git?

**Git advantages**:
- Distributed (setiap developer punya full history)
- Fast & efficient
- Branching yang powerful
- Industry standard (GitHub, GitLab, Bitbucket)

### Git vs GitHub

| Aspek | Git | GitHub |
|-------|-----|--------|
| **Apa** | Version control system | Hosting platform |
| **Fungsi** | Track changes locally | Remote storage & collaboration |
| **CLI** | Command line tool | Web interface + API |
| **Offline** | ✅ Bisa | ❌ Butuh internet |

---

## 2. Git Fundamentals

### Git Configuration

```bash
# Set identity (WAJIB)
git config --global user.name "Nama Anda"
git config --global user.email "email@anda.com"

# Set default editor
git config --global core.editor "vim"

# Set default branch name
git config --global init.defaultBranch main

# Verify config
git config --list
```

**Config Levels**:
- `--global`: User level (semua repo)
- `--local`: Repository specific
- `--system`: System-wide (semua users)

### Git Repository Basics

#### Initialize Repository

```bash
# Create new repo
mkdir my-project
cd my-project
git init

# Verify
ls -la .git/
```

**Apa yang terjadi?**
- Folder `.git/` dibuat (jangan edit manual!)
- Repository kosong terbuat
- Ready untuk tracking files

#### Git Areas

Git punya 3 main areas:

```
Working Directory  →  Staging Area  →  Repository
   (your files)      (git add)         (git commit)
```

**Working Directory**: Files yang sedang Anda edit  
**Staging Area**: Files ready untuk commit  
**Repository**: Committed changes (permanent history)

### Basic Git Commands

#### Check Status

```bash
git status
```

Output menunjukkan:
- Modified files (red = unstaged)
- Staged files (green = ready to commit)
- Untracked files (belum di-add)

#### Add Files to Staging

```bash
# Add specific file
git add filename.txt

# Add all files
git add .

# Add multiple files
git add file1.txt file2.txt

# Add by pattern
git add *.js
```

#### Commit Changes

```bash
# Commit dengan message
git commit -m "Add login feature"

# Commit all modified files (skip staging)
git commit -a -m "Update documentation"

# Multi-line message
git commit
# (opens editor for detailed message)
```

**Good Commit Message**:
```
feat: add user authentication

- Implement JWT authentication
- Add login/register endpoints
- Create middleware for protected routes
```

#### View History

```bash
# View commit history
git log

# One line per commit
git log --oneline

# Graph view
git log --oneline --graph --all

# Limit to last N commits
git log -n 5

# Show changes
git log -p
```

---

## 3. Git Workflow

### Standard Workflow

```bash
# 1. Check current status
git status

# 2. Make changes to files
echo "New feature" >> feature.txt

# 3. Check what changed
git diff

# 4. Stage changes
git add feature.txt

# 5. Commit
git commit -m "feat: add new feature"

# 6. Push to remote (if exists)
git push origin main
```

### Undoing Changes

#### Discard Working Directory Changes

```bash
# Discard changes in specific file
git checkout -- filename.txt

# Discard all changes
git checkout -- .
```

#### Unstage Files

```bash
# Remove from staging (keep changes)
git reset HEAD filename.txt

# Unstage all
git reset HEAD .
```

#### Amend Last Commit

```bash
# Fix last commit message
git commit --amend -m "New message"

# Add forgotten files to last commit
git add forgotten-file.txt
git commit --amend --no-edit
```

#### Revert Commit

```bash
# Create new commit that undoes changes
git revert <commit-hash>

# Revert last commit
git revert HEAD
```

---

## 4. Branching & Merging

### Why Branches?

Branches allow you to:
- Work on features independently
- Test without affecting main code
- Collaborate without conflicts
- Release management

### Branch Operations

#### Create & Switch Branches

```bash
# Create new branch
git branch feature/login

# Switch to branch
git checkout feature/login

# Create and switch (shorthand)
git checkout -b feature/login

# Modern syntax (Git 2.23+)
git switch feature/login
git switch -c feature/new-branch
```

#### List Branches

```bash
# List local branches
git branch

# List all branches (including remote)
git branch -a

# List with last commit
git branch -v
```

#### Delete Branches

```bash
# Delete merged branch
git branch -d feature/login

# Force delete (unmerged)
git branch -D feature/login
```

### Merging

#### Fast-Forward Merge

```bash
# On main branch
git checkout main
git merge feature/login
```

**Fast-forward**: When no commits on main since branch created

#### 3-Way Merge

```bash
git checkout main
git merge feature/login -m "Merge feature/login into main"
```

**3-way**: When both branches have new commits

#### Merge Conflicts

```bash
# When conflict occurs
git merge feature/login
# Auto-merging file.txt
# CONFLICT (content): Merge conflict in file.txt
```

**Resolve conflict**:
1. Open conflicted file
2. Look for conflict markers:
```
<<<<<<< HEAD
Your changes
=======
Their changes
>>>>>>> feature/login
```
3. Edit to resolve
4. Remove markers
5. Stage and commit:
```bash
git add file.txt
git commit -m "Resolve merge conflict"
```

### Branching Strategies

#### Git Flow

```
main         [production]
  |
develop      [staging]
  |
feature/*    [new features]
bugfix/*     [bug fixes]
hotfix/*     [urgent fixes]
```

#### GitHub Flow (Simpler)

```
main         [production]
  |
feature/*    [all changes]
```

**Best Practice**:
```bash
# Branch naming
git checkout -b feature/user-authentication
git checkout -b bugfix/login-error
git checkout -b hotfix/security-patch
```

---

## 5. Remote Repositories

### Add Remote

```bash
# Add remote repository
git remote add origin git@github.com:username/repo.git

# Verify remote
git remote -v

# Show remote details
git remote show origin
```

### Clone Repository

```bash
# Clone via SSH
git clone git@github.com:username/repo.git

# Clone via HTTPS
git clone https://github.com/username/repo.git

# Clone to specific folder
git clone git@github.com:username/repo.git my-folder
```

### Push Changes

```bash
# Push to remote
git push origin main

# Push and set upstream (first time)
git push -u origin main

# Push all branches
git push --all origin

# Push tags
git push --tags
```

### Fetch vs Pull

#### Fetch

```bash
# Download changes (don't merge)
git fetch origin

# View fetched changes
git log origin/main
```

#### Pull

```bash
# Fetch + merge
git pull origin main

# Rebase instead of merge
git pull --rebase origin main
```

**Pull = Fetch + Merge**

### Pull Requests (GitHub)

**Workflow**:
1. Create feature branch
2. Push to GitHub
3. Open Pull Request
4. Code review
5. Merge to main

```bash
# Steps
git checkout -b feature/new-ui
# Make changes
git add .
git commit -m "feat: redesign UI"
git push -u origin feature/new-ui
# Go to GitHub → Create Pull Request
```

---

## 6. Conventional Commits

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | Purpose | Example |
|------|---------|---------|
| `feat` | New feature | `feat: add user profile` |
| `fix` | Bug fix | `fix: resolve login issue` |
| `docs` | Documentation | `docs: update README` |
| `style` | Formatting | `style: format code` |
| `refactor` | Code refactoring | `refactor: simplify logic` |
| `test` | Add tests | `test: add unit tests` |
| `chore` | Maintenance | `chore: update dependencies` |

### Examples

```bash
# Simple
git commit -m "feat: add dark mode"

# With scope
git commit -m "fix(auth): resolve token expiration"

# With body
git commit -m "feat(api): add user endpoints

- GET /api/users
- POST /api/users
- DELETE /api/users/:id"

# Breaking change
git commit -m "feat!: redesign API

BREAKING CHANGE: API v1 is deprecated"
```

---

## 7. Advanced Git

### Stash Changes

```bash
# Save changes temporarily
git stash

# Stash with message
git stash save "WIP: working on feature"

# List stashes
git stash list

# Apply last stash
git stash apply

# Apply and remove from stash
git stash pop

# Apply specific stash
git stash apply stash@{2}

# Drop stash
git stash drop
```

### Cherry Pick

```bash
# Apply specific commit to current branch
git cherry-pick <commit-hash>

# Multiple commits
git cherry-pick <commit1> <commit2>
```

### Rebase

```bash
# Rebase current branch onto main
git checkout feature/login
git rebase main

# Interactive rebase (last 3 commits)
git rebase -i HEAD~3
```

**Interactive rebase options**:
- `pick`: keep commit
- `reword`: change message
- `squash`: combine with previous
- `drop`: remove commit

### Tags

```bash
# Create tag
git tag v1.0.0

# Annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# List tags
git tag

# Push tags
git push --tags

# Delete tag
git tag -d v1.0.0
```

### .gitignore

```bash
# Create .gitignore
cat > .gitignore << 'EOF'
# Node modules
node_modules/

# Environment variables
.env
.env.local

# Build output
dist/
build/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/
EOF

git add .gitignore
git commit -m "chore: add gitignore"
```

---

## 8. Hands-On Exercises

### Exercise 1: Basic Git Workflow

```bash
# 1. Create repository
mkdir git-practice
cd git-practice
git init

# 2. Create files
echo "# Git Practice" > README.md
git add README.md
git commit -m "docs: initial commit"

# 3. Make changes
echo "Learning Git basics" >> README.md
git add README.md
git commit -m "docs: add description"

# 4. View history
git log --oneline

# 5. Create .gitignore
echo "*.log" > .gitignore
git add .gitignore
git commit -m "chore: add gitignore"
```

**Verification**:
- [ ] 3 commits in history
- [ ] .gitignore created
- [ ] All changes committed

---

### Exercise 2: Branching & Merging

```bash
# 1. Create feature branch
git checkout -b feature/add-docs

# 2. Add documentation
echo "## Features" >> README.md
echo "- Git basics" >> README.md
git add README.md
git commit -m "docs: add features section"

# 3. Switch to main
git checkout main

# 4. Make different changes
echo "MIT License" > LICENSE
git add LICENSE
git commit -m "docs: add license"

# 5. Merge feature
git merge feature/add-docs

# 6. View history
git log --oneline --graph --all

# 7. Delete feature branch
git branch -d feature/add-docs
```

**Verification**:
- [ ] Merge successful
- [ ] Both changes present
- [ ] Feature branch deleted

---

### Exercise 3: Handling Conflicts

```bash
# 1. Create two branches
git checkout -b branch-a
echo "Version A" > file.txt
git add file.txt
git commit -m "Add version A"

git checkout main
git checkout -b branch-b
echo "Version B" > file.txt
git add file.txt
git commit -m "Add version B"

# 2. Merge branch-a first
git checkout main
git merge branch-a

# 3. Try merge branch-b (will conflict!)
git merge branch-b

# 4. Resolve conflict
# Edit file.txt manually:
cat > file.txt << 'EOF'
Version A and B combined
EOF

git add file.txt
git commit -m "Merge branch-b (resolve conflict)"

# 5. Cleanup
git branch -d branch-a branch-b
```

**Verification**:
- [ ] Conflict detected
- [ ] Conflict resolved
- [ ] Merge completed

---

### Exercise 4: GitHub Workflow

```bash
# 1. Create repo on GitHub first

# 2. Clone locally
git clone git@github.com:username/test-repo.git
cd test-repo

# 3. Create feature branch
git checkout -b feature/add-readme
echo "# Test Repository" > README.md
git add README.md
git commit -m "docs: add README"

# 4. Push feature branch
git push -u origin feature/add-readme

# 5. Go to GitHub → Create Pull Request

# 6. After merge on GitHub, update local
git checkout main
git pull origin main

# 7. Delete feature branch
git branch -d feature/add-readme
git push origin --delete feature/add-readme
```

**Verification**:
- [ ] PR created on GitHub
- [ ] Changes merged
- [ ] Local updated
- [ ] Branches cleaned up

---

## 9. Troubleshooting

### Issue 1: Accidentally Committed to Wrong Branch

**Solution**:
```bash
# Move commit to correct branch
git checkout correct-branch
git cherry-pick <commit-hash>

# Remove from wrong branch
git checkout wrong-branch
git reset --hard HEAD~1
```

---

### Issue 2: Need to Undo Last Commit

**Keep changes**:
```bash
git reset --soft HEAD~1
```

**Discard changes**:
```bash
git reset --hard HEAD~1
```

---

### Issue 3: Merge Conflict

**Steps**:
```bash
# 1. See conflicted files
git status

# 2. Open and edit files
vim conflicted-file.txt

# 3. Remove conflict markers
# <<<<<<< HEAD
# =======
# >>>>>>> branch

# 4. Stage and commit
git add conflicted-file.txt
git commit -m "Resolve merge conflict"
```

---

### Issue 4: Pushed Wrong Commit

**If not pushed yet**:
```bash
git reset --hard HEAD~1
```

**If already pushed**:
```bash
# Revert (safer - creates new commit)
git revert HEAD
git push origin main
```

---

### Issue 5: Forgot to Add Files

```bash
# Add forgotten files
git add forgotten-file.txt

# Amend last commit
git commit --amend --no-edit
```

---

## 📝 Git Cheat Sheet

### Configuration
```bash
git config --global user.name "Name"
git config --global user.email "email"
git config --list
```

### Basic Commands
```bash
git init                 # Initialize repo
git status              # Check status
git add <file>          # Stage file
git commit -m "msg"     # Commit
git log                 # View history
```

### Branching
```bash
git branch              # List branches
git branch <name>       # Create branch
git checkout <name>     # Switch branch
git checkout -b <name>  # Create + switch
git merge <branch>      # Merge branch
git branch -d <name>    # Delete branch
```

### Remote
```bash
git remote add origin <url>  # Add remote
git push origin main         # Push
git pull origin main         # Pull
git clone <url>             # Clone repo
git fetch origin            # Fetch changes
```

### Undo
```bash
git checkout -- <file>      # Discard changes
git reset HEAD <file>       # Unstage
git commit --amend          # Fix last commit
git revert <commit>         # Revert commit
git reset --hard <commit>   # Reset to commit
```

---

## 🎯 Next Steps

Setelah menguasai Git:

1. **Practice Daily**: Commit setiap perubahan code
2. **Use Branches**: Selalu buat branch untuk fitur baru
3. **Write Good Messages**: Follow conventional commits
4. **Collaborate**: Contribute to open source
5. **Lanjut Workflow**: `/03-docker-basics`

---

## 📚 Resources

- [Pro Git Book](https://git-scm.com/book/en/v2) (Free)
- [Learn Git Branching](https://learngitbranching.js.org/) (Interactive)
- [GitHub Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**Selamat! Anda sudah menguasai Git fundamentals! 🎉**

Lanjut ke: `/03-docker-basics`

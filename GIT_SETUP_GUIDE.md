# Git & GitHub Setup Guide

Since you changed your Windows OS and lost previous data, here's how to set up Git and push to GitHub:

## Quick Setup (Automated)

1. **Run the setup script:**
   ```powershell
   .\setup-git.ps1
   ```

2. **Follow the prompts** to enter your:
   - Git user name
   - Git email (use your GitHub email)
   - GitHub repository URL (if you have one)

## Manual Setup

### Step 1: Configure Git

```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 2: Create Initial Commit

Your files are already staged. Just commit them:

```powershell
git commit -m "Initial commit: Discord clone with auto-friend feature"
```

### Step 3: Add GitHub Remote

**Option A: If you already have a GitHub repository:**

```powershell
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
```

**Option B: If you need to create a new repository:**

1. Go to https://github.com/new
2. Create a new repository (name it `Dosco` or similar)
3. **Don't** initialize with README, .gitignore, or license
4. Copy the repository URL
5. Add it as remote:
   ```powershell
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   ```

### Step 4: Push to GitHub

```powershell
git push -u origin main
```

## Authentication Issues

If you get authentication errors when pushing, you have two options:

### Option 1: Personal Access Token (Recommended)

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with `repo` permissions
3. Copy the token
4. When pushing, use the token as your password (username is your GitHub username)

### Option 2: SSH Keys

1. Generate SSH key:
   ```powershell
   ssh-keygen -t ed25519 -C "your.email@example.com"
   ```

2. Add to SSH agent:
   ```powershell
   Start-Service ssh-agent
   ssh-add ~/.ssh/id_ed25519
   ```

3. Copy public key:
   ```powershell
   cat ~/.ssh/id_ed25519.pub
   ```

4. Add to GitHub: Settings → SSH and GPG keys → New SSH key

5. Change remote URL to SSH:
   ```powershell
   git remote set-url origin git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git
   ```

## Verify Setup

Check your configuration:

```powershell
git config --list
git remote -v
git status
```

## Troubleshooting

- **"remote origin already exists"**: Remove it first: `git remote remove origin`
- **"Authentication failed"**: Use Personal Access Token or SSH keys
- **"Branch 'main' has no upstream"**: Use `git push -u origin main` the first time

## Next Steps

After pushing, you can:
- View your code on GitHub
- Set up GitHub Actions for CI/CD
- Deploy to Vercel or other platforms
- Collaborate with others


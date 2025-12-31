# Quick Fix for GitHub Authentication Error

## The Problem
- Repository URL shows: `Dosco-` (with trailing dash - likely wrong)
- Getting 403 Permission Denied error
- Token authentication window closed

## Solution Steps

### Step 1: Fix Repository Name

The repository name in the URL has a trailing dash. Check your actual GitHub repository name and update:

```powershell
# Option 1: If your repo is named "Dosco"
git remote set-url origin https://github.com/HaiderKazmi655/Dosco.git

# Option 2: If your repo is named "Dosco-main"  
git remote set-url origin https://github.com/HaiderKazmi655/Dosco-main.git

# Option 3: Check what repos you have on GitHub
# Go to: https://github.com/HaiderKazmi655?tab=repositories
```

### Step 2: Clear Cached Credentials

Windows Credential Manager might be using wrong credentials:

```powershell
# Clear Git credentials
git credential-manager erase https://github.com

# Or manually delete from Windows Credential Manager:
# Control Panel > Credential Manager > Windows Credentials
# Delete any entries for "git:https://github.com"
```

### Step 3: Verify Your Token

Make sure your Personal Access Token has:
- ✅ `repo` scope checked
- ✅ Token is not expired
- ✅ Token was copied correctly (no extra spaces)

Create a new token if needed: https://github.com/settings/tokens

### Step 4: Push with Token in URL (Temporary Solution)

If the popup keeps closing, use token directly in URL:

```powershell
# Replace YOUR_TOKEN with your actual token
git remote set-url origin https://HaiderKazmi655:YOUR_TOKEN@github.com/HaiderKazmi655/Dosco.git

# Then push
git push -u origin main
```

**⚠️ WARNING:** Remove token from URL after pushing for security:
```powershell
git remote set-url origin https://github.com/HaiderKazmi655/Dosco.git
```

### Step 5: Alternative - Use SSH Instead

If HTTPS keeps failing, switch to SSH:

1. Generate SSH key (if you don't have one):
```powershell
ssh-keygen -t ed25519 -C "HaiderKazmi655@users.noreply.github.com"
```

2. Add to GitHub: https://github.com/settings/keys

3. Change remote to SSH:
```powershell
git remote set-url origin git@github.com:HaiderKazmi655/Dosco.git
```

4. Push:
```powershell
git push -u origin main
```

## Quick Diagnostic Commands

```powershell
# Check current remote
git remote -v

# Test connection
git ls-remote origin

# Check Git config
git config --list | Select-String "credential"
```


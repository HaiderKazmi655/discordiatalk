# Simple Push Solution for Dosco- Repository

## The Problem
- Repository name is correct: `Dosco-`
- Getting 403 Permission Denied
- Token authentication window closes

## Solution: Use Token Directly in URL

Since the popup keeps closing, we'll use the token directly in the URL temporarily.

### Step 1: Get Your Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Name: "Dosco Push"
4. Check **`repo`** scope (full control of private repositories)
5. Click "Generate token"
6. **COPY THE TOKEN IMMEDIATELY** (you won't see it again!)

### Step 2: Push Using Token

Run this command (replace `YOUR_TOKEN` with your actual token):

```powershell
git remote set-url origin https://HaiderKazmi655:YOUR_TOKEN@github.com/HaiderKazmi655/Dosco-.git
git push -u origin main
```

### Step 3: Remove Token from URL (IMPORTANT!)

After successful push, remove the token for security:

```powershell
git remote set-url origin https://github.com/HaiderKazmi655/Dosco-.git
```

## OR Use the Automated Script

I've created a script that does this safely:

```powershell
.\push-with-token.ps1
```

This script will:
- Ask for your token securely
- Set it up temporarily
- Push your code
- Remove the token automatically

## Alternative: Clear Windows Credentials Manually

If you want to try the popup method again:

1. Open **Control Panel** → **Credential Manager**
2. Go to **Windows Credentials**
3. Find any entries for `git:https://github.com`
4. Delete them
5. Try pushing again: `git push -u origin main`

## Verify Your Token Has Correct Permissions

Your token MUST have:
- ✅ **repo** scope checked (this gives access to repositories)

If it doesn't have `repo` scope, create a new token with it.

## After Successful Push

Your code will be at:
**https://github.com/HaiderKazmi655/Dosco-**


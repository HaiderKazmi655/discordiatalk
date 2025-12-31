# Setup New GitHub Repository - Complete Guide

## Current Situation
- Your project files are in the `Dosco-main` folder
- The old repository has issues
- You want to create a fresh repository

## Quick Setup (Automated)

1. **Navigate to the project folder:**
   ```powershell
   cd Dosco-main
   ```

2. **Run the setup script:**
   ```powershell
   .\setup-new-repo.ps1
   ```

3. **Follow the prompts** to create and push to a new GitHub repository

## Manual Setup

### Step 1: Navigate to Project Folder
```powershell
cd Dosco-main
```

### Step 2: Remove Old Git (if exists)
```powershell
Remove-Item -Recurse -Force .git
```

### Step 3: Initialize New Repository
```powershell
git init
git branch -M main
```

### Step 4: Configure Git
```powershell
git config user.name "HaiderKazmi655"
git config user.email "HaiderKazmi655@users.noreply.github.com"
```

### Step 5: Add and Commit All Files
```powershell
git add .
git commit -m "Initial commit: Discord clone with auto-friend feature"
```

### Step 6: Create GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `Dosco` (or your preferred name)
3. Description: "Discord clone with auto-friend feature"
4. Choose Public or Private
5. **IMPORTANT:** Do NOT check:
   - ❌ Add a README file
   - ❌ Add .gitignore
   - ❌ Choose a license
6. Click "Create repository"

### Step 7: Add Remote and Push

```powershell
# Replace 'Dosco' with your actual repository name
git remote add origin https://github.com/HaiderKazmi655/Dosco.git
git push -u origin main
```

**If push fails with authentication:**
```powershell
# Use token in URL (replace YOUR_TOKEN)
git remote set-url origin https://HaiderKazmi655:YOUR_TOKEN@github.com/HaiderKazmi655/Dosco.git
git push -u origin main

# Then remove token for security
git remote set-url origin https://github.com/HaiderKazmi655/Dosco.git
```

## Verify Everything

After pushing, check:
- ✅ All files are in the repository root (not nested)
- ✅ `package.json` is at root
- ✅ `src/` folder is at root
- ✅ Repository is accessible on GitHub

## Deploy to Vercel

After the new repository is set up:

1. Go to: https://vercel.com/dashboard
2. Click "Add New..." → "Project"
3. Import your new repository
4. **Root Directory:** Leave empty (files are at root)
5. Add environment variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
6. Deploy!

## File Structure After Setup

Your GitHub repository should have:
```
Dosco/
├── package.json          ← At root
├── next.config.ts        ← At root
├── src/                  ← At root
│   ├── app/
│   ├── components/
│   └── lib/
├── public/               ← At root
├── README.md
└── ... (all other files at root)
```

**NOT nested in a subfolder!**

## Troubleshooting

**"Repository already exists"**
- Delete the old repository on GitHub first, or use a different name

**"Authentication failed"**
- Use Personal Access Token (not password)
- Get token: https://github.com/settings/tokens

**"Files still nested"**
- Make sure you're running commands from inside the `Dosco-main` folder
- Check with: `Get-Location` and `Test-Path package.json`


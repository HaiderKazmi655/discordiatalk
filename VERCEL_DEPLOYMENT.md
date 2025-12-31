# Vercel Deployment Guide for Dosco

## ✅ Pre-Deployment Checklist

- [x] Code pushed to GitHub (repository: `Dosco-`)
- [x] Next.js project configured
- [x] Supabase integration ready
- [ ] Supabase credentials ready
- [ ] Vercel account created

## Step 1: Prepare Your Supabase Credentials

Before deploying, you'll need:
1. **Supabase Project URL** - Your Supabase project URL
2. **Supabase Anon Key** - Your Supabase anonymous/public key

Get these from:
- Supabase Dashboard → Your Project → Settings → API
- Or: https://app.supabase.com/project/_/settings/api

## Step 2: Deploy to Vercel

### Option A: Deploy via Vercel Dashboard (Recommended)

1. **Go to Vercel:**
   - Visit: https://vercel.com
   - Sign in with GitHub (use your `HaiderKazmi655` account)

2. **Import Your Project:**
   - Click "Add New..." → "Project"
   - Select your GitHub repository: `HaiderKazmi655/Dosco-`
   - Click "Import"

3. **Configure Project:**
   - **Framework Preset:** Next.js (should auto-detect)
   - **Root Directory:** `./` (or leave default)
   - **Build Command:** `npm run build` (default)
   - **Output Directory:** `.next` (default)
   - **Install Command:** `npm install` (default)

4. **Add Environment Variables:**
   Click "Environment Variables" and add:
   
   ```
   NEXT_PUBLIC_SUPABASE_URL = your_supabase_project_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY = your_supabase_anon_key
   ```
   
   Example:
   ```
   NEXT_PUBLIC_SUPABASE_URL = https://abcdefghijklmnop.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

5. **Deploy:**
   - Click "Deploy"
   - Wait for build to complete (usually 2-3 minutes)

### Option B: Deploy via Vercel CLI

1. **Install Vercel CLI:**
   ```powershell
   npm i -g vercel
   ```

2. **Login to Vercel:**
   ```powershell
   vercel login
   ```

3. **Deploy:**
   ```powershell
   vercel
   ```
   
   Follow the prompts:
   - Link to existing project? No (first time)
   - Project name: `dosco` (or your choice)
   - Directory: `./`
   - Override settings? No

4. **Add Environment Variables:**
   ```powershell
   vercel env add NEXT_PUBLIC_SUPABASE_URL
   vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY
   ```

5. **Redeploy with environment variables:**
   ```powershell
   vercel --prod
   ```

## Step 3: Configure Supabase for Production

After deployment, update your Supabase settings:

1. **Go to Supabase Dashboard:**
   - Settings → API → URL Configuration
   - Add your Vercel domain to allowed origins

2. **Update CORS Settings (if needed):**
   - In Supabase SQL Editor, run:
   ```sql
   -- Allow your Vercel domain
   -- This is usually handled automatically, but check if you have CORS issues
   ```

## Step 4: Verify Deployment

1. **Check Build Logs:**
   - Go to Vercel Dashboard → Your Project → Deployments
   - Click on the latest deployment
   - Check for any errors

2. **Test Your App:**
   - Visit your Vercel URL (e.g., `dosco.vercel.app`)
   - Test registration/login
   - Test the auto-friend feature
   - Test DM functionality

## Step 5: Custom Domain (Optional)

1. **Add Domain in Vercel:**
   - Go to Project Settings → Domains
   - Add your custom domain
   - Follow DNS configuration instructions

2. **Update Supabase Settings:**
   - Add custom domain to Supabase allowed origins

## Environment Variables Reference

Your app needs these environment variables:

| Variable | Description | Where to Get It |
|----------|-------------|-----------------|
| `NEXT_PUBLIC_SUPABASE_URL` | Your Supabase project URL | Supabase Dashboard → Settings → API |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anonymous key | Supabase Dashboard → Settings → API |

## Troubleshooting

### Build Fails

**Error: "Module not found"**
- Make sure all dependencies are in `package.json`
- Run `npm install` locally to verify

**Error: "Environment variable not found"**
- Check that environment variables are set in Vercel
- Make sure variable names match exactly (case-sensitive)

### App Works But Database Connection Fails

1. **Check Supabase URL and Key:**
   - Verify they're correct in Vercel environment variables
   - Check Supabase dashboard to ensure project is active

2. **Check Supabase Database:**
   - Make sure you've run `setup_supabase.sql` in your Supabase SQL Editor
   - Verify tables exist: `users`, `friend_requests`, `dms`, etc.

3. **Check CORS:**
   - Supabase should allow Vercel domains automatically
   - If issues persist, check Supabase settings

### Auto-Friend Feature Not Working

1. **Check Database:**
   - Verify `friend_requests` and `dms` tables exist
   - Check if new users are being created properly

2. **Check Logs:**
   - Vercel Dashboard → Functions → View logs
   - Look for any errors in `autoAddUserToAllFriends` function

## Post-Deployment

After successful deployment:

1. ✅ Test user registration
2. ✅ Test login
3. ✅ Verify auto-friend feature (register 2 users, check if they're friends)
4. ✅ Test DM functionality
5. ✅ Test server/channel features

## Useful Links

- **Vercel Dashboard:** https://vercel.com/dashboard
- **Supabase Dashboard:** https://app.supabase.com
- **Your Repository:** https://github.com/HaiderKazmi655/Dosco-
- **Vercel Docs:** https://vercel.com/docs

## Next Steps

- [ ] Deploy to Vercel
- [ ] Set up environment variables
- [ ] Test all features
- [ ] Set up custom domain (optional)
- [ ] Configure monitoring/analytics (optional)


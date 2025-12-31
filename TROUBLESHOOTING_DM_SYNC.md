# Troubleshooting: DMs Not Showing After Sync

## Issue
After clicking "Sync All Friends", the DM list remains empty.

## Possible Causes & Solutions

### 1. Page Not Refreshed
**Solution:** The page should auto-refresh, but if it doesn't:
- Manually refresh the page (F5 or Ctrl+R)
- Or hover over "Direct Messages" and click the refresh icon (↻)

### 2. Username Case Sensitivity
**Check:** Make sure usernames match exactly (case-sensitive)

**Verify in Supabase:**
1. Go to Supabase Dashboard → Table Editor → `dms` table
2. Check if DM entries exist
3. Verify `pair_a` and `pair_b` match your username exactly

**Test Query:**
```sql
SELECT * FROM dms 
WHERE pair_a = 'your_username' OR pair_b = 'your_username';
```

### 3. Sync Didn't Complete
**Check:**
- Look for success message after clicking "Sync All Friends"
- Check browser console for errors (F12)
- Check Vercel function logs

**Re-run Sync:**
- Click "Sync All Friends" again (safe to run multiple times)
- Wait for success message

### 4. Database Connection Issues
**Check:**
- Verify Supabase environment variables are set in Vercel
- Check Supabase project is active
- Verify database tables exist (`dms`, `friend_requests`)

### 5. Real-time Subscription Not Working
**Solution:**
- Refresh the page
- The DMs should load on page load even if real-time fails

## Manual Debugging Steps

### Step 1: Check if DMs Exist in Database

Run this in Supabase SQL Editor:
```sql
-- Check all DMs
SELECT * FROM dms ORDER BY time DESC;

-- Check DMs for specific user (replace 'username' with your username)
SELECT * FROM dms 
WHERE pair_a = 'username' OR pair_b = 'username';
```

### Step 2: Check Friend Requests

```sql
-- Check all friend requests
SELECT * FROM friend_requests WHERE status = 'accepted';

-- Check for specific user
SELECT * FROM friend_requests 
WHERE (from = 'username' OR to = 'username') 
AND status = 'accepted';
```

### Step 3: Test API Endpoint

Open browser console (F12) and run:
```javascript
fetch('/api/sync-friends', { method: 'POST' })
  .then(res => res.json())
  .then(data => {
    console.log('Sync result:', data);
    // Then refresh DMs
    window.location.reload();
  });
```

### Step 4: Check Browser Console

1. Open Developer Tools (F12)
2. Go to Console tab
3. Look for errors when:
   - Page loads
   - After clicking sync
   - When fetching DMs

## Quick Fixes

### Fix 1: Force Refresh
1. Click the refresh icon (↻) next to "Direct Messages"
2. Or refresh the entire page

### Fix 2: Re-run Sync
1. Go to `/admin/users`
2. Click "Sync All Friends" again
3. Wait for success message
4. Refresh DM list

### Fix 3: Check Username
1. Check your username in the bottom left (e.g., "Haider X #haid")
2. Make sure it matches exactly in the database
3. Usernames are case-sensitive!

### Fix 4: Manual SQL Sync
If the API isn't working, run this in Supabase SQL Editor:

```sql
-- This creates DMs for all user pairs
-- (Replace with your actual usernames)

INSERT INTO dms (pair_a, pair_b, "user", text, time)
SELECT 
  LEAST(u1.username, u2.username) as pair_a,
  GREATEST(u1.username, u2.username) as pair_b,
  u1.username as "user",
  NULL as text,
  EXTRACT(EPOCH FROM NOW()) * 1000 as time
FROM users u1
CROSS JOIN users u2
WHERE u1.username < u2.username
ON CONFLICT DO NOTHING;
```

## Still Not Working?

1. **Check Vercel Logs:**
   - Go to Vercel Dashboard → Your Project → Functions
   - Check logs for `/api/sync-friends`
   - Look for errors

2. **Check Supabase Logs:**
   - Go to Supabase Dashboard → Logs
   - Check for database errors

3. **Verify Environment Variables:**
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## Expected Behavior

After successful sync:
- ✅ All users should see all other users in their DM list
- ✅ Friend requests should be "accepted" for all pairs
- ✅ DM entries should exist for all user pairs
- ✅ DMs should appear immediately (or after refresh)


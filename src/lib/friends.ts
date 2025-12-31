import { supabase } from "./supabase";

/**
 * Helper function to get sorted pair for DM consistency
 */
function getSortedPair(username1: string, username2: string): [string, string] {
  return username1 < username2 ? [username1, username2] : [username2, username1];
}

/**
 * Automatically adds a new user to all existing users as friends and creates DMs
 * This function:
 * 1. Creates accepted friend requests between newUser and all existing users (bidirectional)
 * 2. Creates DM entries for all user pairs
 */
export async function autoAddUserToAllFriends(newUsername: string): Promise<void> {
  try {
    // Get all existing users except the new user
    const { data: existingUsers, error: usersError } = await supabase
      .from("users")
      .select("username")
      .neq("username", newUsername);

    if (usersError) {
      console.error("Error fetching existing users:", usersError);
      return;
    }

    if (!existingUsers || existingUsers.length === 0) {
      // No existing users, nothing to do
      return;
    }

    // Prepare friend requests (bidirectional - both ways)
    // Check existing friend requests first to avoid duplicates
    const friendRequestsToInsert = [];
    for (const existingUser of existingUsers) {
      // Check if friend request already exists (both directions)
      const { data: existingFR1 } = await supabase
        .from("friend_requests")
        .select("id")
        .eq("from", newUsername)
        .eq("to", existingUser.username)
        .maybeSingle();

      const { data: existingFR2 } = await supabase
        .from("friend_requests")
        .select("id")
        .eq("from", existingUser.username)
        .eq("to", newUsername)
        .maybeSingle();

      // Only create if they don't exist
      if (!existingFR1) {
        friendRequestsToInsert.push({
          from: newUsername,
          to: existingUser.username,
          status: "accepted",
        });
      } else {
        // Update existing to accepted if it's not already
        await supabase
          .from("friend_requests")
          .update({ status: "accepted" })
          .eq("id", existingFR1.id);
      }

      if (!existingFR2) {
        friendRequestsToInsert.push({
          from: existingUser.username,
          to: newUsername,
          status: "accepted",
        });
      } else {
        // Update existing to accepted if it's not already
        await supabase
          .from("friend_requests")
          .update({ status: "accepted" })
          .eq("id", existingFR2.id);
      }
    }

    // Insert new friend requests
    if (friendRequestsToInsert.length > 0) {
      await supabase.from("friend_requests").insert(friendRequestsToInsert);
    }

    // Prepare DM entries for all pairs
    const dmEntries = [];
    for (const existingUser of existingUsers) {
      const [pair_a, pair_b] = getSortedPair(newUsername, existingUser.username);
      
      // Check if DM already exists
      const { data: existingDM } = await supabase
        .from("dms")
        .select("id")
        .eq("pair_a", pair_a)
        .eq("pair_b", pair_b)
        .maybeSingle();

      // Only create if it doesn't exist
      if (!existingDM) {
        dmEntries.push({
          pair_a,
          pair_b,
          user: newUsername, // Initial user field
          text: null,
          time: Date.now(),
        });
      }
    }

    // Insert all DM entries
    if (dmEntries.length > 0) {
      await supabase.from("dms").insert(dmEntries);
    }
  } catch (error) {
    console.error("Error in autoAddUserToAllFriends:", error);
  }
}

/**
 * Syncs all existing users - adds everyone to everyone's friend list
 * This is useful for migrating existing users
 */
export async function syncAllUsersAsFriends(): Promise<void> {
  try {
    // Get all users
    const { data: allUsers, error: usersError } = await supabase
      .from("users")
      .select("username");

    if (usersError || !allUsers || allUsers.length === 0) {
      console.error("Error fetching users:", usersError);
      return;
    }

    // Create friend requests for all pairs
    const friendRequests = [];
    const dmEntries = [];

    for (let i = 0; i < allUsers.length; i++) {
      for (let j = i + 1; j < allUsers.length; j++) {
        const user1 = allUsers[i].username;
        const user2 = allUsers[j].username;

        // Bidirectional friend requests
        friendRequests.push({
          from: user1,
          to: user2,
          status: "accepted",
        });
        friendRequests.push({
          from: user2,
          to: user1,
          status: "accepted",
        });

        // DM entry
        const [pair_a, pair_b] = getSortedPair(user1, user2);
        dmEntries.push({
          pair_a,
          pair_b,
          user: user1,
          text: null,
          time: Date.now(),
        });
      }
    }

    // Insert friend requests (check for existing ones first in batch)
    // First, get all existing friend requests to avoid duplicates
    const { data: existingFRs } = await supabase
      .from("friend_requests")
      .select("from, to");

    const existingFRSet = new Set<string>();
    if (existingFRs) {
      for (const fr of existingFRs) {
        existingFRSet.add(`${fr.from}-${fr.to}`);
      }
    }

    const friendRequestsToInsert = [];

    for (const req of friendRequests) {
      const key = `${req.from}-${req.to}`;
      if (!existingFRSet.has(key)) {
        friendRequestsToInsert.push(req);
      }
      // If it already exists, we don't need to do anything
      // The status should already be set appropriately
    }

    // Batch insert new friend requests
    if (friendRequestsToInsert.length > 0) {
      // Insert in chunks to avoid overwhelming the database
      const chunkSize = 50;
      for (let i = 0; i < friendRequestsToInsert.length; i += chunkSize) {
        const chunk = friendRequestsToInsert.slice(i, i + chunkSize);
        await supabase.from("friend_requests").insert(chunk);
      }
    }

    // Check existing DMs and only insert new ones
    if (dmEntries.length > 0) {
      // Batch check for existing DMs
      const existingDMs = new Set<string>();
      for (const dm of dmEntries) {
        const { data } = await supabase
          .from("dms")
          .select("id")
          .eq("pair_a", dm.pair_a)
          .eq("pair_b", dm.pair_b)
          .maybeSingle();
        if (data) {
          existingDMs.add(`${dm.pair_a}-${dm.pair_b}`);
        }
      }

      // Filter out existing DMs
      const newDMs = dmEntries.filter(
        (dm) => !existingDMs.has(`${dm.pair_a}-${dm.pair_b}`)
      );

      if (newDMs.length > 0) {
        await supabase.from("dms").insert(newDMs);
      }
    }
  } catch (error) {
    console.error("Error in syncAllUsersAsFriends:", error);
  }
}


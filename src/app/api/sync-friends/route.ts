import { NextResponse } from "next/server";
import { supabase } from "@/lib/supabase";
import { syncAllUsersAsFriends } from "@/lib/friends";

export async function POST() {
  try {
    await syncAllUsersAsFriends();
    return NextResponse.json({ success: true, message: "All users synced as friends" });
  } catch (error) {
    console.error("Error syncing friends:", error);
    return NextResponse.json(
      { success: false, error: "Failed to sync friends" },
      { status: 500 }
    );
  }
}


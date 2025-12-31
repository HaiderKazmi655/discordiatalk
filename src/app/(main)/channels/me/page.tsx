"use client";
import { MeSidebar } from "@/components/layout/MeSidebar";
import { useAuth } from "@/context/AuthContext";

export default function MePage() {
    const { user } = useAuth();

    if (!user) {
        return (
            <div className="flex w-full h-full">
                <MeSidebar />
                <div className="flex-1 bg-dc-bg-primary flex items-center justify-center text-dc-text-muted">
                    Please log in to view your messages
                </div>
            </div>
        );
    }

    return (
        <div className="flex w-full h-full">
            <MeSidebar />
            <div className="flex-1 bg-dc-bg-primary flex items-center justify-center text-dc-text-muted">
                <div className="text-center">
                    <h2 className="text-2xl font-bold text-white mb-2">Welcome to Direct Messages</h2>
                    <p className="text-dc-text-muted">Select a conversation from the sidebar to start chatting</p>
                </div>
            </div>
        </div>
    );
}

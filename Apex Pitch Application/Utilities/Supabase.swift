//
//  SupabaseAuth.swift
//  Apex Pitch Application
//
//  Created by admin on 25/3/2026.
//
import Supabase
import Foundation

// Shared Supabase client configured once and reused across authentication and data screens.
let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://tkdvjvwisqxnkrruvfne.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRrZHZqdndpc3F4bmtycnV2Zm5lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ0MzM3NzQsImV4cCI6MjA5MDAwOTc3NH0.iWHePe_sJdFYZIIyyDELmzcCsFNsauVkr1dlWs9DQyc",
    options: .init(
        auth: .init(emitLocalSessionAsInitialSession: true) 
    )
)

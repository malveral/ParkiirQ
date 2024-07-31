//
//  Supabase.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//


import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://kngbntopjckfmgftjisb.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtuZ2JudG9wamNrZm1nZnRqaXNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjIzOTAxNTYsImV4cCI6MjAzNzk2NjE1Nn0.qmrGiP0jzCpyB5gjO5FWMn_1sNexc5_ODDZZqR2OJp8"
)

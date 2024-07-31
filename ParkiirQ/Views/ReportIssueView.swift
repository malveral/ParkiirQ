//
//  ReportIssueView.swift
//  ParkiirQ
//
//  Created by Marcell JW on 31/07/24.
//

import SwiftUI

struct ReportIssueView: View {
    @Environment(\.dismiss) var dismiss
    
    enum ReportIssueOptions: CaseIterable, Identifiable, CustomStringConvertible {
        case informasi
        case navigasi
        case lokasi
        case teknis
        
        var id: Self { self }

        var description: String {

            switch self {
            case .informasi:
                return "Informasi tempat parkir kurang akurat"
            case .navigasi:
                return "Rute atau navigasi kurang akurat"
            case .lokasi:
                return "Lokasi saya tidak terbaca"
            case .teknis:
                return "Lainnya"
            }
        }
    }
    
    @State private var selectedOption: ReportIssueOptions = .informasi
    @State private var issueDesc: String = ""
                    
    var body: some View {
        Form {
            Picker("Isu", selection: $selectedOption) {
                ForEach(ReportIssueOptions.allCases) { option in
                    Text(String(describing: option))
                }
            }.pickerStyle(.inline)
            
            Section("Deskripsi"){
                TextField("Deskripsi", text: $issueDesc, prompt: Text("Elaborasikan masalah Anda"))
                    .lineLimit(6)
                    .multilineTextAlignment(.leading)
            }
            
            Button {
                Task {
                    let _ = try? await supabase
                        .from("reports")
                        .insert(Issue(
                            category: selectedOption.description, 
                            description: issueDesc)
                        )
                        .execute()
                    
                    await MainActor.run {
                        dismiss()
                    }
                }
            } label: {
                Label(
                    "Laporkan Masalah",
                    systemImage: SymbolUtilities().getSymbol(.reportIssue)
                )
            }
        }
    }
}

#Preview {
    ReportIssueView()
}

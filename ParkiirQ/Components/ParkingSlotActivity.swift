//
//  ParkingSlotActivity.swift
//  ParkiirQ
//
//  Created by Marcell JW on 31/07/24.
//

import SwiftUI

//struct ParkingSlotActivity: View {
//    @State private var activity: Activity<TimerAttributes>? = nil
//    var body: some View {
//        VStack(spacing: 16) {
//            Button("Start Activity") {
//                startActivity()
//            }
//            Button("Stop Activity") {
//                stopActivity()
//            }
//        }
//        .buttonStyle(.borderedProminent)
//        .controlSize(.large)
//    }
//    func startActivity() {
//        let attributes = TimerAttributes(timerName: "Dummy Timer")
//        let state TimerAttributes.TimerStatus (endTime: Date().addingTimeInterval(60*5))
//        I
//        activity = try? Activity<TimerAttributes>.request(attributes: attributes, contentState: state, pushType: nil)
//    }
//    func stopActivity() {
//        let state TimerAttributes.TimerStatus (endTime: .now)
//        Task {
//            await activity?.end(using: state, dismissalPolicy: .immediate)
//        }
//    }
//    func updateActivity() {
//        let state TimerAttributes.TimerStatus (endTime: Date().addingTimeInterval(60 * 10))
//        Task {
//            await activity?.update(using: state)
//        }
//    }
//}

//
//#Preview {
//    ParkingSlotActivity()
//}

//
//  ParkingSlotAttribute.swift
//  ParkiirQ
//
//  Created by Marcell JW on 31/07/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ContentViewKW: View {
    
    @State private var activity: Activity<ParkingSlotAttribute>? = nil
    var body: some View {
        VStack(spacing: 16) {
            Button("Start Activity") {
//                startActivity()
            }
            Button("Stop Activity") {
                
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    
    func startActivity() {
        let attributes = ParkingSlotAttribute(appName: "ParkiirQ")
        let state = ParkingSlotAttribute.LiveParkingSlotData(someName: "String")
        
        activity = try? Activity<ParkingSlotAttribute>.request(attributes: attributes, contentState: state, pushType: nil)
    }
    
    func stopActivity() {
        
        Task {
            let state = ParkingSlotAttribute.LiveParkingSlotData(someName: "Some Name")
            let content = ActivityContent(state: state, staleDate: .now)
            await activity?.end(content, dismissalPolicy: .immediate)
        }
    }
    
    
}

#Preview {
    ContentViewKW()
}
    
struct ParkingSlotAttribute: ActivityAttributes {

    public typealias LiveParkingSlotData = ContentState

    public struct ContentState: Codable, Hashable {
        var someName: String
//        var courierName: String
//        var deliveryTime: Date
    }
    
    var appName: String = "ParkiirQ"
    var message: String
    
    init(appName: String, message: String = "Did you park at A_25") {
        self.appName = appName
        self.message = message
    }
    
}

/// This will appear
struct ParkingSlotActivityView: View {
    
    let context: ActivityViewContext<ParkingSlotAttribute>
    
    var body: some View {
        VStack {
            Text(context.attributes.appName)
                .font(.headline)
            
            HStack {
                Button("No") {
                    
                }
                Button("Yes") {
                    
                }
            }
            
        }
        .padding(.horizontal)
    }
    

}

//#Preview {
//    ParkingSlotActivityView(context: context)
//}

struct Tutorial_Widget: Widget {
    
    let kind: String = "Tutorial_Widget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ParkingSlotAttribute.self) { context in
            ParkingSlotActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                
                DynamicIslandExpandedRegion(.leading) {
                    Text("Dynamic")
                        .opacity(0)
//                    dynamicIslandExpandedLeadingView(context: context)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Dynamic")
                        .opacity(0)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("Dynamic")
                        .opacity(0)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Dynamic")
                        .opacity(0)
                }
                
            } compactLeading: {
                Text("Dynamic")
                    .opacity(0)
            } compactTrailing: {
                Text("Dynamic")
                    .opacity(0)
            } minimal: {
                Text("Dynamic")
                    .opacity(0)
            }
            .keylineTint(.cyan)
            
            
        }
    }
}
 
//@main
struct Widgets: 	WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            Tutorial_Widget()
        }
    }
}

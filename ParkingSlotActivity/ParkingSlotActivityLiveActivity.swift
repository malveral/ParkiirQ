//
//  ParkingSlotActivityLiveActivity.swift
//  ParkingSlotActivity
//
//  Created by Marcell JW on 31/07/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ParkingSlotActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ParkingSlotActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ParkingSlotActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ParkingSlotActivityAttributes {
    fileprivate static var preview: ParkingSlotActivityAttributes {
        ParkingSlotActivityAttributes(name: "World")
    }
}

extension ParkingSlotActivityAttributes.ContentState {
    fileprivate static var smiley: ParkingSlotActivityAttributes.ContentState {
        ParkingSlotActivityAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ParkingSlotActivityAttributes.ContentState {
         ParkingSlotActivityAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ParkingSlotActivityAttributes.preview) {
   ParkingSlotActivityLiveActivity()
} contentStates: {
    ParkingSlotActivityAttributes.ContentState.smiley
    ParkingSlotActivityAttributes.ContentState.starEyes
}

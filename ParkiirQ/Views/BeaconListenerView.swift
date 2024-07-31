//
//  BeaconListenerView.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import SwiftUI
import Supabase
import SwiftyJSON

struct BeaconListenerView: View {
    
    let finishAlert: () -> Void
    
    enum BeaconState {
        case parking(Int, String)
        case leaving(Int, String)
    }
    
    @State private var beaconState: BeaconState?
    
    var body: some View {
        Text("Hello world")
            .task {
                await listenToBeacon()
            }
            .alert(item: $beaconState) { state in
                switch state {
                case .parking(_,_):
                    return Text("Parking detected")
                case .leaving(_,_):
                    return Text("Parking finish detected")
                }
            } actions: { state in
                switch state {
                case .parking(let int, let string):
                    Button("Park") {
                        finishAlert()
                    }
                case .leaving(let int, let string):
                    Button("Leave") {
                       finishAlert()
                    }
                }
                
                
                Button("Close", role: .cancel) {
                    beaconState = nil
                    finishAlert()
                }
            } message: { state in
                switch state {
                case .parking(_,let code):
                    return Text("If you intend to park on \(code), we can start the live activity now if you click 'Park'")
                case .leaving(_,let code):
                    return Text("Click 'Leave' to end the live activity now!")
                }
            }
    }
    
    func listenToBeacon() async {
        print("Listening to beacon")
        let channel = supabase.channel("parkiirq")
        
        let broadcastMessage = channel.broadcastStream(event: "beacon")
        
        await channel.subscribe()
        
        Task {
            for await message in broadcastMessage {
                let values =  JSON(message["payload"]?.value ?? [])
                print("beacon received", values)
                let action = values["action"].string
                let id = values["id"].int
                let code = values["code"].string
                
                guard
                    let action = action,
                    let id = id,
                    let code = code else
                {
                    return
                }
                
                await MainActor.run {
                    print("Received")
                    self.beaconState = action == "p"
                    ? .parking(id, code)
                    : .leaving(id, code)
                }
                
            }
        }
    }
}

#Preview {
    BeaconListenerView() {}
}

//
//  ContentView.swift
//  CursorTravel
//
//  Created by Terkel on 5/15/20.
//  Copyright © 2020 Terkel.com. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mouseData: Mouse
    
    var body: some View {
        Group {
            VStack {
                Picker(selection: $mouseData.distance.unit, label: Text("Unit")) {
                    ForEach(unitData) { unit in
                        Text(unit.short).tag(unit.id)
                    }
                }
                Divider().padding(.bottom, 10)
                MetricView(label: "Session", value: mouseData.formattedSession())
                MetricView(label: "Total Distance", value: mouseData.formattedTotal())
                Divider().padding(.top, 10)
                HStack {
                    Button(action: {
                        NSApplication.shared.terminate(self)
                    }) {
                        Text("Quit")
                    }
                    Button(action: {
                        self.mouseData.reset()
                    }) {
                        Text("Reset")
                    }
                }
            }
        }
        .frame(width: 300.0)
        .padding(.all, 10)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Mouse())
    }
}

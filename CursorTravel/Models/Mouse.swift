//
//  Mouse.swift
//  CursorTravel
//
//  Created by Terkel on 5/16/20.
//  Copyright © 2020 Terkel.com. All rights reserved.
//

import SwiftUI
import Combine

private let CM = 0.0264583333

/// Used to wrap data to be stored in UserDefault.
/// The base unit is centimeters
struct DistanceData: Codable {
    var total = 0.0
    var session = 0.0
    var unit = 0
}

final class Mouse: ObservableObject  {
    @Published var distance = DistanceData()
    static let saveKey = "SavedData"
    private var point = NSEvent.mouseLocation
    private var timer: Timer?
    
    init() {
        restore()
        start()
    }
    
    // MARK: - Listener
    
    func start() {
        timer = Timer.init(timeInterval: 0.1, repeats: true, block: {_ in
            let mouse = NSEvent.mouseLocation
            if (!mouse.equalTo(self.point)) {
                // Calculate Distance
                let a = self.point.x - mouse.x
                let b = self.point.y - mouse.y
                let length = Double(sqrt(a * a + b * b))
                let cm =  length * CM
                self.distance.session = self.distance.session + cm
                self.distance.total = self.distance.total + cm
                self.point = mouse
            }
        })
        RunLoop.main.add(timer!, forMode: .default)
    }
    
    
    func stop() {
        timer?.invalidate()
    }
    
    // MARK: - Print / Formatting
    
    func getTotalDistance() -> Double {
        return distance.total / unitData[distance.unit].multiplier
    }
    
    func getSessionDistance() -> Double {
        return distance.session / unitData[distance.unit].multiplier
    }
    
    func formattedTotal() -> String {
        return String(format: "%.2f %@", getTotalDistance(), unitData[distance.unit].short)
    }
    
    func formattedSession() -> String {
        return String(format: "%.2f %@", getSessionDistance(), unitData[distance.unit].short)
    }
    
    // MARK: - Persistant Data
    
    private func restore() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode(DistanceData.self, from: data) {
                print("Restore")
                self.distance = decoded
            }
        }
        self.distance.session = 0.0
    }
    
    func save() {
        print("Save")
        if let encoded = try? JSONEncoder().encode(distance) {
            print("Saved")
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func reset() {
        distance.total = 0
        distance.session = 0
        self.objectWillChange.send()
        UserDefaults.standard.removeObject(forKey: Self.saveKey)
    }
}

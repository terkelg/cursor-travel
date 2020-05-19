//
//  Unit.swift
//  CursorTravel
//
//  Created by Terkel on 5/16/20.
//  Copyright © 2020 Terkel.com. All rights reserved.
//

import SwiftUI

struct Unit: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var short: String
    var multiplier: Double
}

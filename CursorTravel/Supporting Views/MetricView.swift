//
//  MetricView.swift
//  CursorTravel
//
//  Created by Terkel on 5/16/20.
//  Copyright © 2020 Terkel.com. All rights reserved.
//

import SwiftUI

struct MetricView: View {
    var label: String
    var value: String

    var body: some View {
        HStack(spacing: 10.0) {
            Image("SetSquare")
                .resizable()
                .colorInvert()
                .aspectRatio(contentMode: .fit)
                .offset(x: 0, y: 1)
                .frame(width:18, height: 18)
            Text(label)
            Spacer()
            Text(value)
                .font(.system(.footnote, design: .monospaced))
        }
    }
}

struct MetricView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MetricView(label: "Total", value: "0.00 m")
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

//
//  SliderView.swift
//  brokenithm-swiftui
//
//  Created by Owen Cramer on 9/11/24.
//

import SwiftUI

struct SliderView: View {
    @Binding var lanesTouching: [UInt8]
    @Binding var connection: Listener?
    
    var airOn: Bool

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(0 ..< 16) { i in

                    Rectangle()
                        .fill(getColor(con: connection, i: i, laneSplit: false))
                        .foregroundStyle(.ultraThinMaterial)
                        .overlay {
                            if i < 15 {
                                Rectangle()
                                    .fill(getColor(con: connection, i: i, laneSplit: true))
                                    .frame(width: 5)
                                    .padding(.leading, proxy.size.width / 16)
                            }
                        }
                }
            }
        }
    }
    
    private func getColor(con: Listener?, i: Int, laneSplit: Bool) -> Color {
        if con == nil {
            return .black
        }
        
        if laneSplit {
            return Color(red: Double((con?.ledArray[(i * 2) * 3 + 4])!) / 255, green: Double((con?.ledArray[(i * 2) * 3 + 3])!) / 255, blue: Double((con?.ledArray[(i * 2) * 3 + 5])!) / 255)
        }
        
        return Color(red: Double((con?.ledArray[(i * 2) * 3 + 1])!) / 255, green: Double((con?.ledArray[(i * 2) * 3])!) / 255, blue: Double((con?.ledArray[(i * 2) * 3 + 2])!) / 255)
    }
    
}

#Preview {
    SliderView(lanesTouching: .constant(Array(repeating: 0, count: 32)), connection: .constant(nil), airOn: true)
}

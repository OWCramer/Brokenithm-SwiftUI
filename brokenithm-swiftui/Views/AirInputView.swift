//
//  AirInputView.swift
//  brokenithm-swiftui
//
//  Created by Owen Cramer on 9/11/24.
//

import SwiftUI

struct AirInputView: View {
    var size: CGFloat
    @Binding var airTouching: [UInt8]
    @Binding var connection: Listener?
    let airLanes = [4, 5, 2, 3, 0, 1]

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                ForEach(0 ..< 6) { i in
                    Rectangle()
                        .fill(airTouching[airLanes[i]] == 128 ? Color.gray.opacity(0.5) : .black)
                        .border(Color.white, width: 1)
                }
            }
        }
        .frame(maxHeight: size)
    }
}

#Preview {
    AirInputView(size: CGFloat(100), airTouching: .constant(.init(repeating: 0, count: 6)), connection: .constant(nil))
}

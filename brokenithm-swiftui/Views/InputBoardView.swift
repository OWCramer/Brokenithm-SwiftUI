//
//  InputBoardView.swift
//  brokenithm-swiftui
//
//  Created by Owen Cramer on 9/11/24.
//

import SwiftUI

struct InputBoardView: View {
    @State var lanesTouching: [UInt8] = Array(repeating: 0, count: 32)
    @State var airTouching: [UInt8] = Array(repeating: 0, count: 6)
    @Binding var connection: Listener?
    @Binding var airOn: Bool
    @Binding var airOption: String

    var body: some View {
        GeometryReader { proxy in
            let rectWidth = proxy.size.width / 16
            let airHeight = proxy.size.height / (airOption == "Normal" ? 3 : airOption == "Small" ? 4.5 : 2)
            let airBlockHeight = airHeight / 6
            VStack(spacing: 0) {
                if airOn {
                    AirInputView(size: airHeight, airTouching: $airTouching, connection: $connection)
                }
                SliderView(lanesTouching: $lanesTouching, connection: $connection, airOn: airOn)
            }
            .sensoryFeedback(.success, trigger: airOption)
            .gesture(
                SpatialEventGesture()
                    .onChanged { events in
                        lanesTouching = Array(repeating: 0, count: 32)
                        airTouching = Array(repeating: 0, count: 6)
                        for event in events {
                            if event.phase == .active {
                                let y = event.location.y
                                let x = event.location.x
                                let laneBeingTouched: Int = .init(x / rectWidth)
                                let airBeingTouched: Int = .init(y / airBlockHeight)
                                let locate = x / rectWidth
                                let locateAir = y / airBlockHeight
                                if (y < airHeight && airOn) || (y < 0) {
                                    laneChange(location: locate, lane: laneBeingTouched, isDelete: true)
                                    if airOn, y > 0 {
                                        airChange(location: locateAir, airLane: airBeingTouched)
                                    }
                                } else {
                                    laneChange(location: locate, lane: laneBeingTouched)
                                }
                                connection?.sendInput(arrayLane: lanesTouching.reversed(), arrayAir: airTouching)

                            } else {
                                let y = event.location.y
                                let x = event.location.x
                                let laneBeingTouched: Int = .init(x / rectWidth)
                                let airBeingTouched: Int = .init(y / airBlockHeight)
                                let locate = x / rectWidth
                                let locateAir = y / airBlockHeight
                                if airOn {
                                    airChange(location: locateAir, airLane: airBeingTouched, isDelete: true)
                                }
                                laneChange(location: locate, lane: laneBeingTouched, isDelete: true)
                                connection?.sendInput(arrayLane: lanesTouching.reversed(), arrayAir: airTouching)
                            }
                        }
                    }
                    .onEnded { events in
                        for _ in events {
                            airTouching = Array(repeating: 0, count: 6)
                            lanesTouching = Array(repeating: 0, count: 32)
                            connection?.sendInput(arrayLane: lanesTouching.reversed(), arrayAir: airTouching)
                        }
                    }
            )
        }
    }

    private func laneChange(location: CGFloat, lane: Int, isDelete: Bool = false) {
        var laneBeingTouched = lane
        var assignee: UInt8 = 99
        if isDelete {
            assignee = 0
        } else {
            assignee = 128
        }
        if laneBeingTouched > 15 {
            laneBeingTouched = 15
        }
        if laneBeingTouched < 0 {
            laneBeingTouched = 0
        }
        if location - CGFloat(laneBeingTouched) > 0.75 {
            lanesTouching[laneBeingTouched * 2] = assignee
            if !(laneBeingTouched * 2 >= 15) {
                lanesTouching[(laneBeingTouched + 1) * 2] = assignee
            }
        } else if location - CGFloat(laneBeingTouched) < 0.25 {
            lanesTouching[laneBeingTouched * 2] = assignee
            if !(laneBeingTouched * 2 <= 1) {
                lanesTouching[(laneBeingTouched - 1) * 2] = assignee
            }
        } else {
            lanesTouching[laneBeingTouched * 2] = assignee
        }
    }

    private func airChange(location: CGFloat, airLane: Int, isDelete: Bool = false) {
        var laneBeingTouched = airLane
        let airLanes = [4, 5, 2, 3, 0, 1]
        var assignee: UInt8 = 99
        if isDelete {
            assignee = 0
        } else {
            assignee = 128
        }
        if laneBeingTouched > 5 {
            laneBeingTouched = 5
        }
        if laneBeingTouched < 0 {
            laneBeingTouched = 0
        }
        airTouching[airLanes[laneBeingTouched]] = assignee
    }
}

#Preview {
    InputBoardView(connection: .constant(nil), airOn: .constant(true), airOption: .constant("Normal"))
}

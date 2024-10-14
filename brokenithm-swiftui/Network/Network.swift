//
//  Network.swift
//  brokenithm-swiftui
//
//  Created by Owen Cramer on 8/30/24.
//

import Foundation
import Network

@Observable
class Listener {
    init() throws {
        self.listener = try NWListener(using: .tcp, on: 24864)
    }

    var listener: NWListener
    var status = "Not Connected"
    var connection: NWConnection?
    var ledArray: [UInt8] = Array(repeating: 0, count: 97)
    
    func start() {
        self.listener.service = .init(type: "_brokenithm._tcp.")
        self.listener.newConnectionHandler = { conn in
            self.connection = conn
            conn.start(queue: .main)
            self.didAccept()
        }
        self.listener.start(queue: .main)
    }
    
    func restart() throws {
        if self.connection == nil { return }
        self.ledArray = Array(repeating: 0, count: 97)
        self.connection?.cancel()
        self.status = "Not Connected"
        self.listener = try NWListener(using: .tcp, on: 24864)
        self.start()
    }
    
    func didAccept() {
        self.sendInitialMessage()
        self.status = "Connected"
        self.recieveLED()
    }
    
    func sendInitialMessage() {
        if self.connection == nil { return }
        let byteArray: [UInt8] = [3, 87, 69, 76]
        self.connection!.send(content: byteArray, completion: .contentProcessed { error in
            if let sad = error {
                print("sender: send failed, error: \(sad)")
                return
            }
        })
    }
    
    func insertCoin() {
        if self.connection == nil { return }
        let byteArray: [UInt8] = [4, 70, 78, 67, 1]
        self.connection!.send(content: byteArray, completion: .contentProcessed { error in
            if let sad = error {
                print("sender: send failed, error: \(sad)")
                return
            }
        })
    }
    
    func tapCard() {
        if self.connection == nil { return }
        let byteArray: [UInt8] = [4, 70, 78, 67, 2]
        self.connection!.send(content: byteArray, completion: .contentProcessed { error in
            if let sad = error {
                print("sender: send failed, error: \(sad)")
                return
            }
        })
    }
    
    func enableAir(enabled: Bool) {
        if self.connection == nil { return }
        let byteArray: [UInt8] = [4, 65, 73, 82, enabled ? 1 : 0]
        self.connection!.send(content: byteArray, completion: .contentProcessed { error in
            if let sad = error {
                print("sender: send failed, error: \(sad)")
                return
            }
        })
    }
    
    func sendInput(arrayLane: [UInt8], arrayAir: [UInt8]) {
        if self.connection == nil { return }
        let byteArray: [UInt8] = [41, 73, 78, 80]
        let arrayToSend = byteArray + arrayAir + arrayLane
        self.connection!.send(content: arrayToSend, completion: .contentProcessed { error in
            if let sad = error {
                print("sender: send failed, error: \(sad)")
                return
            }
        })
    }
    
    func recieveLED() {
        if self.connection == nil { return }
        self.connection?.receive(minimumIncompleteLength: 1, maximumLength: 100, completion: { data, _, isComplete, error in
            if let sad = error {
                print(sad)
            }
            if isComplete {
                try? self.restart()
            } else {
                if data == nil { return }
                if (data![0] == 99 && data![1] == 76 && data![2] == 69 && data![3] == 68 ) {
                    var tempArray: [UInt8] = Array(repeating: 0, count: 97)
                    for i in 0 ..< data!.count - 3 {
                        tempArray[i] = data![i]
                    }
                    self.ledArray = tempArray.reversed()
                }
                self.recieveLED()
            }
        })
    }
}

//
//  Serverconnection.swift
//  imageconnection
//
//  Created by 송민재 on 2020/01/21.
//  Copyright © 2020 송민재. All rights reserved.
//

import Foundation
import Network


@available(OSX 10.14, *)
class ServerConnection{
    let MTU = 65536
    
    private static var nextID: Int = 0
    let connection: NWConnection
    let id: Int
    
    var remessage: String?
    
    init(nwConnection: NWConnection) {
        connection = nwConnection
        id = ServerConnection.nextID
        ServerConnection.nextID += 1
    }
    
    var didStopCallback: ((Error?) -> Void)? = nil
    
    private func stateDidChange(to state: NWConnection.State){
        switch state{
        case .setup:
            break
        case .waiting(let error):
            fail(error: error)
        case .ready:
            print("connection is ready at \(id)")
        case .failed(let error):
            fail(error: error)
        case .cancelled:
            break
        case .preparing:
            break
        @unknown default:
            break
            
        }
    }
    
    //   ********************************* start // stop or fail or end ************************************
    func start(){
        print("connection at \(id) will start")
        connection.stateUpdateHandler = self.stateDidChange(to: )
        setupReceive()
        connection.start(queue: .main)
    }
    func stop(){
        print("connection at \(id) will stop!!!")
    }
    //
    private func stop(error: Error?){   //hmmmmmm..............
        connection.stateUpdateHandler = nil
        connection.cancel()
        if let didStopCallback = didStopCallback{
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
    private func end(){
        print("connection at \(id) ends!")
        stop(error: nil)
    }
    private func fail(error : Error){
        print("connection at \(id) fail with \(error)")
        stop(error: error)
    }
    //   ******************************** sending & receiving ********************************** // private func이었음
    func setupReceive() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: MTU){(data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                let message = String(data: data, encoding: .utf8)
                print("connection \(self.id) did receive, data: \(data as NSData) string: \(message ?? "-")")
                self.send(data: data)
                self.remessage = message ?? "-"
            }
            if isComplete {
                self.end()
            } else if let error = error {
                self.fail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }
    
    func send(data: Data) {
        self.connection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.fail(error: error)
                return
            }
            print("connection \(self.id) did send, data: \(data as NSData)")
        }))
    }
}

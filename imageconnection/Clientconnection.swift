//
//  Clientconnection.swift
//  imageconnection
//
//  Created by 송민재 on 2020/01/21.
//  Copyright © 2020 송민재. All rights reserved.
//

import Foundation
import Network

@available(OSX 10.14, *)
class ClientConnection{
    let MTU2 = 65536
    let nwConnection: NWConnection
    let queue = DispatchQueue(label: "initialize another queue")
    
    init (nwConnection: NWConnection){
        self.nwConnection = nwConnection
    }
    
    var didStopCallback: ((Error?) -> Void)? = nil
    
    private func stateDidChange(to state: NWConnection.State){
        switch state{
        case .setup:
            break
        case .waiting(let error):
            fail(error: error)
        case .ready:
            print("client connection is ready")
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
    
    func start(){
        print("conection starts in client side at clinet")
        nwConnection.stateUpdateHandler = stateDidChange(to: )
        setupReceive()
        nwConnection.start(queue: queue)
    }
    
    func stop(){
        print("connection at will stop!!!")
        stop(error: nil)
    }
    //
    private func stop(error: Error?){   //hmmmmmm..............
        self.nwConnection.stateUpdateHandler = nil
        self.nwConnection.cancel()
        if let didStopCallback = self.didStopCallback{
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
    private func end(){
        print("connection ends!")
        self.stop(error: nil)
    }
    private func fail(error : Error){
        print("connection fail with \(error)")
        self.stop(error: error)
    }
    // ******************************** sending & receiving **********************************
    private func setupReceive() {
        nwConnection.receive(minimumIncompleteLength: 1, maximumLength: MTU2) {(data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                let message = String(data: data, encoding: .utf8)
                print("connection did receive in CLIENT, data: \(data as NSData) string: \(message ?? "-")")
                //self.send(data: data)
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
        nwConnection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.fail(error: error)
                return
            }
                print("connection did send, data: \(data as NSData)")
        }))
    }
    
    
    
}

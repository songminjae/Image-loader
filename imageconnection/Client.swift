//
//  Client.swift
//  imageconnection
//
//  Created by 송민재 on 2020/01/21.
//  Copyright © 2020 송민재. All rights reserved.
//

import Foundation
import Network

@available(OSX 10.14, *)
class Client {
    let host: NWEndpoint.Host
    let port: NWEndpoint.Port
    let connection: ClientConnection
    
    init(host: String, port: UInt16){
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)!
        let nwConnection = NWConnection(host: self.host, port: self.port, using: .tcp)
        connection = ClientConnection(nwConnection: nwConnection)
        
    }
    
    func start(){
        print("client started at host: \(host), port: \(port)")
        connection.didStopCallback = didStopCallback(error: )
        connection.start()
    }
    
    func stop(){
        connection.stop()
    }
    
    func send(data: Data){
        connection.send(data: data)
    }
    
    func didStopCallback(error: Error?) {
        if error == nil {
            exit(EXIT_SUCCESS)
        } else {
            exit(EXIT_FAILURE)
        }
    }
    
}

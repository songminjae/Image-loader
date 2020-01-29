//
//  Server.swift
//  imageconnection
//
//  Created by 송민재 on 2020/01/21.
//  Copyright © 2020 송민재. All rights reserved.
//

import Foundation
import Network
//import CFNetwork
@available(OSX 10.14, *)
class Server{
    let port : NWEndpoint.Port  // 타입 정의
    let listener : NWListener
    private var connectionsByID: [Int: ServerConnection] = [:]
    
    init(port: UInt16){
        self.port = NWEndpoint.Port(rawValue: port)!
        listener = try! NWListener(using: .tcp, on: self.port)
    }
    
    private func Accept(nwConnection: NWConnection) {  // making accept
        let connection = ServerConnection(nwConnection: nwConnection)
        self.connectionsByID[connection.id] = connection
        
        connection.didStopCallback = { _ in
            self.connectionstop(connection)
        }
        connection.start()
        connection.send(data: "Welcome you are connection: \(connection.id)".data(using: .utf8)!)
        print("server did open connection \(connection.id)")
    }

    private func connectionstop(_ connection: ServerConnection){
        self.connectionsByID.removeValue(forKey: connection.id)
        print("server close connection")
    }
    
    
///
    func start() throws {      //stateupdatehandler는. (NWlistener.state -> void) 변환하는 함수
        print("server starting ")
        listener.stateUpdateHandler = self.stateDidChange(fromto: )
        listener.newConnectionHandler = self.Accept(nwConnection: )
        
        listener.start(queue: .main)
    }
    
    private func stop(){
        self.listener.newConnectionHandler = nil
        self.listener.stateUpdateHandler = nil
        self.listener.cancel()
        for c in self.connectionsByID.values{ // quiting all connection by using ids
            c.didStopCallback = nil
            c.stop()
        }
        self.connectionsByID.removeAll()
        
    }
    
    func stateDidChange(fromto ls: NWListener.State){ //state show by state of listener
        switch ls{
        case .setup:
            break
        case .waiting(_):
            break
        case .ready:
            print("listener is ready!!!")
        case .failed(_):
            print("server fail")
            exit(EXIT_FAILURE)
        case .cancelled:
            break
        @unknown default:
            break
        }
    }
    //
    func receive(receivedmessage: String){
        for c in self.connectionsByID.values{
            receivedmessage = c.
        }
        
    }
    
}

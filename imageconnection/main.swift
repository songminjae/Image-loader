//
//  main.swift
//  imageconnection
//
//  Created by 송민재 on 2020/01/21.
//  Copyright © 2020 송민재. All rights reserved.
//

import Foundation

if #available(macOS 10.14, *) {
func serveron(port: UInt16){
    let server = Server(port: port)
    try! server.start()
}
    
func clientstart(host: String, port: UInt16){
    let client = Client(host: host, port: port)
    client.start()
    while(true) {
      var command = readLine(strippingNewline: true)
      switch (command){
      case "exit":
          client.stop()
      default:
          break
      }
      client.connection.send(data: (command?.data(using: .utf8))!)
    }
    
}
/*
let a = CommandLine.arguments[1]  // command should be  ex) swift run tcpsocket 0 / swift run tcpsocket 1
print("shit \(a)")
switch (a){
case "0":
    serveron(port: 7000)
case "1":
    clientstart(host: "localhost", port: 7000)
default:
    break
}
RunLoop.current.run()
*/
  
//serveron(port: 7000)
//RunLoop.current.run()
//clientstart(host: "localhost", port: 7000)
//RunLoop.current.run()
    
}

    


else{
    print("version not correct")
    exit(EXIT_FAILURE)
    
}

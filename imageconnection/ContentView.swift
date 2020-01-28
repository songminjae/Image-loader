//
//  ContentView.swift
//  imageconnection
//
//  Created by 송민재 on 2020/01/21.
//  Copyright © 2020 송민재. All rights reserved.
//

import SwiftUI
import Foundation


struct ContentView: View {
    
    @State var totalclicked: Int = 0
    @State private var message: String = ""
    
    var body: some View {
        VStack{
            Text("\(totalclicked)")
            Button(action: {self.totalclicked = self.totalclicked + 1
                ServerOn(port: 7777)
            }){
                Text("서버")
            }
            
            Button(action: {self.totalclicked = self.totalclicked - 1
                //ClientStart(host: "143.248.140.100", port: 7777)
                let client = Client(host: "143.248.140.100", port: 7777)
                client.start()
            }){
                Text("클라이언트")
            }
            
            TextField("input text", text: $message) //message라는 변수에 input text저장
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



// *****************************
func ServerOn(port: UInt16){
    let server = Server(port: port)
    try! server.start()
}


func ClientStart(host: String, port: UInt16){
    let client = Client(host: host, port: port)
    client.start()
    /*
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
    */
}

//
//  ContentView.swift
//  imageconnection
//
//  Created by 송민재 on 2020/01/21.
//  Copyright © 2020 송민재. All rights reserved.
//

import SwiftUI
import Foundation
//import UIKit


struct ContentView: View {
    
    @State var totalclicked: Int = 0
    @State private var message: String = ""
    
    let server = Server(port: 7777)
    let client = Client(host: "localhost", port: 7777)
    @State private var receivedmessage: String = ""
    
    @State private var showImagePicker : Bool = false
    @State private var image : Image? = nil
    
    @State private var cpsimage: UIImage?
    @State private var showimage: Image?
    
    var body: some View {
        VStack{
            Text("\(totalclicked)")
            
            Button(action: {self.totalclicked = self.totalclicked + 1
                //ServerOn(port: 7777)
                try! self.server.start()
            }){
                Text("서버")
            }
            
            Button(action: {self.totalclicked = self.totalclicked - 1
                //ClientStart(host: "143.248.140.100", port: 7777)
                //let client = Client(host: "143.248.140.100", port: 7777)
                self.client.start()
            }){
                Text("클라이언트")
            }
            
            TextField("input text", text: $message) //message(String)라는 변수에 input text저장
            
            Button(action: {self.totalclicked = self.totalclicked + 1
                self.cpsimage = UIImage(named: "cpsimage")
                print("shit")
                if self.cpsimage?.pngData() != nil {
                    print("shit2")
                    self.client.connection.send(data: (self.cpsimage?.pngData())!)
                }
                //self.testmessage = String(data: self.cpsimage?.pngData() ?? "-", encoding: .utf8) ?? "-"
                
                //let cpsimagedata = self.cpsimage?.pngData()
                
                self.client.connection.send(data: (self.message.data(using: .utf8))!)
                
                //self.client.connection.send(data: (self.cpsimage?.pngData())!)
                
            }){
                Text("send")
            }
            
            Button(action: {self.totalclicked = self.totalclicked + 1
                for c in self.server.connectionsByID.values{
                    
                    self.receivedmessage = c.remessage ?? "-"
                }
                
            }){
                Text("receive")
            }
            
            Text("this is what received: \(receivedmessage)")
        
            // ************************************************
            
            image?.resizable().scaledToFit()
            Button("Open Camera"){
                self.showImagePicker = true
            }.padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(5)
            
            showimage?.resizable().scaledToFit()
            
        }.sheet(isPresented: self.$showImagePicker){
            PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
        }.onAppear(perform: loadimage)
    }
    
    func loadimage(){
        showimage = Image("cpsimage")
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var isShown    : Bool
    @Binding var image      : Image?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}

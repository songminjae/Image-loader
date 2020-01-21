//
//  ContentView.swift
//  imageconnection
//
//  Created by 송민재 on 2020/01/21.
//  Copyright © 2020 송민재. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var totalclicked: Int = 0
    
    var body: some View {
        VStack{
            Text("\(totalclicked)")
            Button(action: {self.totalclicked = self.totalclicked + 1}){
                Text("Server ON")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



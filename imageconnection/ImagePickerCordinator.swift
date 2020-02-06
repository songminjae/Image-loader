//
//  ImagePickerCordinator.swift
//  imageconnection
//
//  Created by 송민재 on 2020/02/06.
//  Copyright © 2020 송민재. All rights reserved.
//

import Foundation
import SwiftUI

struct PhotoCaptureView: View {
    
    @Binding var showImagePicker    : Bool
    @Binding var image              : Image?
    
    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $image)
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), image: .constant(Image("")))
    }
}

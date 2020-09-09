//
//  UploadPhotoButton.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/4/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

class UploadPhotoButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func savePhoto(image:UIImage) {
        
        //Call the photo service to store the photo
        PhotoService.savePhotoToFirebase(image: image)
    }
    
}

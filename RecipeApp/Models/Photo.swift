//
//  Photo.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/4/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Photo {
    
    var photoId:String?
    var recipeId:String?
    var urlString:String?
    
    init? (snapshot: QueryDocumentSnapshot) {
        
        //Parse the data out
        let data = snapshot.data()
        
        let photoId = data["photoId"] as? String
        let recipeId = data["recipeId"] as? String
        let urlString = data["urlString"] as? String
        
        //Check for missing data
        if photoId == nil || recipeId == nil || urlString == nil {
            return nil
        }
        
        //Set our properties
        self.photoId = photoId
        self.recipeId = recipeId
        self.urlString = urlString
        
    }
    
    
    
}

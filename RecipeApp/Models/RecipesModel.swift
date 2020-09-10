//
//  RecipesModel.swift
//  RecipeApp
//
//  Created by Mishan Wong on 8/28/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import Foundation
import Firebase

//This stores all the codes to connect and query Firebase database


protocol RecipesModelProtocol {
    
    func recipesRetrieved(recipes:[Recipe])
}

class RecipesModel {
    
    var delegate:RecipesModelProtocol?
    
    func getRecipes() {
        
        //Get a reference to the database
        let db = Firestore.firestore()
        
        //Get all the recipes
        db.collection("recipes").getDocuments { (snapshot, error) in
            
            //Check for errors
            if error == nil && snapshot != nil {
                
                var recipes = [Recipe]()
                
                //Parse the documents into recipes
                //Loop through every single document in the snapshot, force unwrap bcos we already checked that it's not nil
                for doc in snapshot!.documents {
                    
                    //TODO: Convert url from String type to UIImage type
                    let r = Recipe(recipeId: doc["recipeId"] as! String, dishName: doc["dishName"] as! String, ingredients: doc["ingredients"] as! Array, seasonings: doc["seasonings"] as! Array, instructions: doc["instructions"] as! Array, url: doc["url"] as? String)
                    
                    recipes.append(r)
                }
                
                //Call the delegate and pass back the notes - this is why we set ViewController as the delegate for the RecipesModel
                
                DispatchQueue.main.async {
                    self.delegate?.recipesRetrieved(recipes: recipes)

                }
                
                
            }
            
        }
        
        
    }
    
    
    
}

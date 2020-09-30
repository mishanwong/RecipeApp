//
//  Recipe.swift
//  RecipeApp
//
//  Created by Mishan Wong on 8/28/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import Foundation

struct Recipe {
    
    //Add the properties of this structure
    var recipeId:String
    var dishName:String
    var ingredients = [String]() //Create an empty array of String
    var seasonings = [String]()
    var instructions = [String]()
    var urlString:String?

}



//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 8/28/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var seasoningsTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    var recipe:Recipe?
    var recipesModel:RecipesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up UI
        ingredientsTextView.layer.cornerRadius = 5
        seasoningsTextView.layer.cornerRadius = 5
        instructionsTextView.layer.cornerRadius = 5
        

                        
        if recipe != nil {
            
            title = "Recipe"
            
            //Populate fields
            dishNameLabel.text = recipe?.dishName
            
            //Loop through each ingredient in ingredients array, and display all items
            let ingredientsArray = recipe?.ingredients
            for i in 0...(ingredientsArray!.count - 1) {
                ingredientsTextView.text += "\(i+1). " + ingredientsArray![i] + "\n"
                
            }
            
            //Loop through each seasoning in seasonings array, and display all items
            let seasoningsArray = recipe?.seasonings
            for i in 0...(seasoningsArray!.count - 1) {
                seasoningsTextView.text += "\(i+1). " + seasoningsArray![i] + "\n"
                
            }
            
            //Loop through each instruction in instructions array, and display all items
            let instructionsArray = recipe?.instructions
            for i in 0...(instructionsArray!.count - 1) {
                instructionsTextView.text += "\(i+1). " + instructionsArray![i] + "\n"
                
            }
            
            
            
        }
        

    }
    

    

}

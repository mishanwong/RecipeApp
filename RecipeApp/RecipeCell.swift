//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by Mishan Wong on 9/25/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeLabel: UILabel!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipeToDisplay:Recipe?
    
    func displayRecipe(_ recipe:Recipe) {
        
        //Keep a reference to the article
        recipeToDisplay = recipe
        
        //Set the title
        recipeLabel.text = recipeToDisplay!.dishName
        
        //Download and display the image
        
        guard recipeToDisplay!.urlString != nil else {
            print("No urlString")
            return
        }
        
        
        //Create url string
        let urlString = recipeToDisplay!.urlString!
        print(urlString)
        
        //Create the URL object
        let url = URL(string: urlString)
        print(url)
        
        //Check that the url isn't nil
        guard url != nil else {
            print("Couldn't create url object")
            return
        }
        
        //Get a URLSession
        let session = URLSession.shared
        
        //Create a data task
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            //Check that there were no errors
            if error == nil && data != nil {
                
                //Display the image data in the image view
                
                DispatchQueue.main.async {
                    self.recipeImage.image = UIImage(data: data!)

                } // End DispatchQueue
                
            } // End if error
        } // End data task
        
        
        //Kick off the data task
        dataTask.resume()
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
    
}

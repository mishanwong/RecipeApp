//
//  ViewController.swift
//  RecipeApp
//
//  Created by Mishan Wong on 8/28/20.
//  Copyright © 2020 Mishan Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var recipesModel = RecipesModel()
    private var recipes:[Recipe] = [Recipe]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Recipe List"
        
        //Set up a search view controller -- now this is just a dummy
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //Set delegate and datasource for the table
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set self as the delegate for the notes model
        recipesModel.delegate = self
                
        //Retrieve all notes
        recipesModel.getRecipes()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mainToDetail" {
            let recipeViewController = segue.destination as! RecipeViewController
            
            //If the user has selected a row, transition to RecipeViewController
            if tableView.indexPathForSelectedRow != nil {
                
                //Set the recipe and recipesModel properties of the RecipeViewController
                recipeViewController.recipe = recipes[tableView.indexPathForSelectedRow!.row] //this returns an integer
            }
            
            //Pass the selected recipe to the recipeViewController
            recipeViewController.recipesModel = self.recipesModel
            
        }
                
    } //End override
    
   @IBAction func addButtonTapped(_ sender: Any) {
        let addRecipeVC = AddRecipeViewController()
        let navigationController = UINavigationController(rootViewController: addRecipeVC)
        navigationController.modalPresentationStyle = .automatic
        present(navigationController, animated: true)
    
        //performSegue(withIdentifier: "mainToAdd", sender: self)
    }
    
} //End class

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        
        //TODO: Customize cell
        //let imageLabel = cell.viewWithTag(2) as? UIImageView
        
        let dishNameLabel = cell.viewWithTag(1) as? UILabel
        dishNameLabel?.text = recipes[indexPath.row].dishName
        
        //Return the cell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: -
        
    }
}

extension ViewController: RecipesModelProtocol {
    
    func recipesRetrieved(recipes: [Recipe]) {
        
        //Set the recipes property and refresh the table view
        self.recipes = recipes
        
        //Refresh the tableview
        tableView.reloadData()
        
    }
}

//
//  CategoryStorage.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 10/02/25.
//

import UIKit

class CategoryStorage {
    
    private let storageKey = "taskCategories" //Storage Key
    
    static let shared = CategoryStorage() //Common shared reference
    
    private init() {} //Constructor
    
    //Fetch Categories Method
    func getCategories() -> [TaskCategoryModel] {
        //Fetch from UserDefaults with key
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder() //JSON Decoder Object
            return (try? decoder.decode([TaskCategoryModel].self, from: data)) ?? [] //Decode date
        }
        //Return empty array if no data available
        return [TaskCategoryModel(name: "Default", colorHex: "#000000")]
    }
    
    //Save Categories Method
    func saveCategories(_ categories: [TaskCategoryModel]) {
        let encoder = JSONEncoder() //JSON Encoder Object
        //Encode data
        if let data = try? encoder.encode(categories) {
            UserDefaults.standard.set(data, forKey: storageKey) //Write to UserDefaults
        }
    }
    
    //Add Single Category
    func addCategory(name: String, color: UIColor) {
        var categories = getCategories() //Fetch Categories
        let newCategory = TaskCategoryModel(name: name, colorHex: color.toHex(), isEditing: false) //Create new category
        categories.append(newCategory) //Append category
        saveCategories(categories) //Write to UserDefaults
    }
}

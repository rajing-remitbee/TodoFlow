//
//  CategoryStorage.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 10/02/25.
//

import UIKit

class CategoryStorage {
    
    private let storageKey = "taskCategories"
    
    static let shared = CategoryStorage()
    
    private init() {}
    
    func getCategories() -> [TaskCategoryModel] {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            return (try? decoder.decode([TaskCategoryModel].self, from: data)) ?? []
        }
        return []
    }
    
    func saveCategories(_ categories: [TaskCategoryModel]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(categories) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    func addCategory(name: String, color: UIColor) {
        var categories = getCategories()
        let newCategory = TaskCategoryModel(name: name, colorHex: color.toHex())
        categories.append(newCategory)
        saveCategories(categories)
    }
}

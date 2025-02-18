//
//  TaskStorage.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 13/02/25.
//

import UIKit

class TaskStorage {
    
    static let shared = TaskStorage() //TaskStorage Object
    
    private let storageKey = "tasks" //Storage Key
    
    //Save Tasks method
    func saveTasks(_ tasks: [TaskModel]) {
        //Encode to JSON
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: storageKey) //Store tasks
        }
    }
    
    //Fetch Tasks method
    func getTasks() -> [TaskModel] {
        //Fetch the tasks
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decodedTasks = try? JSONDecoder().decode([TaskModel].self, from: savedData) {
            //Decode from JSON and return
            return decodedTasks
        }
        return []
    }
    
    //Add Task method
    func addTask(_ task: TaskModel) {
        var tasks = getTasks() // Retrieve existing tasks
        tasks.insert(task, at: 0) // Insert new task at the beginning
        saveTasks(tasks) // Save updated list
    }
    
    //Remove Task Method
    func removeTask(_ task: TaskModel) {
        var tasks = getTasks()
        if let index = tasks.firstIndex(where: { $0.title == task.title && $0.date == task.date }) {
            tasks.remove(at: index)
            saveTasks(tasks) // Update UserDefaults
        }
    }
}

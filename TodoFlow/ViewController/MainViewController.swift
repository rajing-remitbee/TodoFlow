//
//  ViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 05/02/25.
//

import UIKit

class MainViewController: UIViewController {
    
    var dates: [Date] = []
    var taskSection: [TaskSectionModel] = []
    
    @IBOutlet var profileImageView: UIImageView! //ProfileImageView Component
    @IBOutlet var dataCollectionView: UICollectionView! //CollectionView Component
    @IBOutlet var taskTableView: UITableView! //TableView Component

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Table View
        taskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
        //ProfileView - Corner Radius
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        //CollectionView Data and Delegate Sources
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        
        //TableView Data and Delegate Sources
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        generateDates()
        
        generateTasks()
        
        // Scroll to today's date
        let todayIndex = dates.firstIndex { Calendar.current.isDate($0, inSameDayAs: Date()) } ?? 0
        dataCollectionView.scrollToItem(at: IndexPath(item: todayIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    private func generateDates() {
        //Calendar Object
        let calendar = Calendar.current
        let today = Date()
        
        //Generate dates from last 7days to next 7days
        for offset in -7..<7 {
            if let date = calendar.date(byAdding: .day, value: offset, to: today) {
                dates.append(date)
            }
        }
        
        //Reload the data in the collection view
        dataCollectionView.reloadData()
    }
    
    private func generateTasks() {
        let calendar = Calendar.current //Current Calendar
        let today = Date() //Today's Date
        
        //Sample tasks
        let tasks = [
            TaskModel(title: "Buy groceries", date: today),
            TaskModel(title: "Call John", date: today),
            TaskModel(title: "Finish report", date: calendar.date(byAdding: .day, value: 1, to: today)!),
            TaskModel(title: "Gym workout", date: calendar.date(byAdding: .day, value: -1, to: today)!),
            TaskModel(title: "Read a book", date: calendar.date(byAdding: .day, value: 2, to: today)!),
        ]
        // Group tasks by date
        let groupedTasks = Dictionary(grouping: tasks) { task in
            calendar.startOfDay(for: task.date) // Normalize date to start of day
        }
        
        // Create TaskSection objects
        taskSection = groupedTasks.map { date, tasks in
            TaskSectionModel(date: date, tasks: tasks)
        }.sorted { $0.date < $1.date } // Sort sections by date
        
        //Reload data in table
        taskTableView.reloadData()
    }

}


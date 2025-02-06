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
    @IBOutlet var bottomView: UIView! //BottomView Component

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Border for bottom view
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: 1)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        bottomView.layer.addSublayer(topBorder)
        
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
        
        let workCategory = TaskCategoryModel(name: "Work", color: UIColor.blue)
        let personalCategory = TaskCategoryModel(name: "Personal", color: UIColor.red)
        
        //Sample tasks
        let tasks = [
            TaskModel(title: "Buy groceries", date: today, category: personalCategory),
            TaskModel(title: "Call John", date: today, category: personalCategory),
            TaskModel(title: "Finish report", date: calendar.date(byAdding: .day, value: 1, to: today)!, category: workCategory),
            TaskModel(title: "Gym workout", date: calendar.date(byAdding: .day, value: -1, to: today)!, category: personalCategory),
            TaskModel(title: "Read a book", date: calendar.date(byAdding: .day, value: 2, to: today)!, category: personalCategory),
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


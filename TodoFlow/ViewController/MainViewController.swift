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
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController {
                
            // Present as overlay
            bottomSheetVC.modalPresentationStyle = .overCurrentContext
            bottomSheetVC.modalTransitionStyle = .crossDissolve

            self.present(bottomSheetVC, animated: true, completion: nil)
        }
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
            TaskModel(title: "Standup Call", date: calendar.date(byAdding: .day, value: 3, to: today)!, category: workCategory),
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

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Cell count
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Get the current cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCollectionViewCell
        //Get the date from Date array
        let date = dates[indexPath.row]
        //Get current calendar
        let calendar = Calendar.current
        //Get today's date
        let today = Date()
        //Check if date is today
        let isToday = calendar.isDate(date, inSameDayAs: today)
        //Check if date is past
        let isPast = date < today && !isToday
        //Set data inside cell
        cell.configure(with: date, isToday: isToday, isPast: isPast)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Selected Date
        let selectedDate = dates[indexPath.row]
        
        // Find the section index for the selected date
        if let sectionIndex = taskSection.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) {
            let indexPath = IndexPath(row: 0, section: sectionIndex)
            taskTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Sections count
        return taskSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Date Formatter Object
        let dateFormatter = DateFormatter()
        //Today date
        let today = Calendar.current.startOfDay(for: Date())
        //Task Date
        let taskDate = Calendar.current.startOfDay(for: taskSection[section].date)

        //Day Formatter
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE" //Full day string

        if taskDate == today {
            //Today format
            return "Today  •  \(dayFormatter.string(from: taskSection[section].date))"
        } else if taskDate == Calendar.current.date(byAdding: .day, value: 1, to: today) {
            //Tomorrow Format
            return "Tomorrow  •  \(dayFormatter.string(from: taskSection[section].date))"
        } else {
            //Other day Format
            dateFormatter.dateFormat = "MMM d"
            return "\(dateFormatter.string(from: taskSection[section].date))  •  \(dayFormatter.string(from: taskSection[section].date))"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Tasks count
        return taskSection[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Individual Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        //Individual task
        let task = taskSection[indexPath.section].tasks[indexPath.row]
        //Cell configuration for the task
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            //Font color
            headerView.textLabel?.textColor = UIColor(hex: "#7E8491")
            //Font size
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        }
    }
}


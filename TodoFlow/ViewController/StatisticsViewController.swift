//
//  StatisticsViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 18/02/25.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet var filterView: UISegmentedControl!
    
    @IBOutlet var completedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Corner Radius
        filterView.layer.cornerRadius = 10
        
        //Default to Weekly
        filterView.selectedSegmentIndex = 0
        //Update for weekly
        updateStatistics(for: .weekly)
        
    }
    
    //On Back Button Tap Action
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //On Segment Filter Change Action
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                updateStatistics(for: .weekly) //Update for weekly
            case 1:
                updateStatistics(for: .monthly) //Update for monthly
            case 2:
                updateStatistics(for: .yearly) //Update for yearly
            case 3:
                updateStatistics(for: .all) //Update for all tasks
            default:
                break
        }
    }
    
    func updateStatistics(for filter: StatisticsFilter) {
        let filteredTasks = filterTasks(for: filter) //Filter tasks based on segment
        let completedTasks = filteredTasks.filter { $0.isCompleted } //Filter completed tasks
        
        let totalTasks = filteredTasks.count //Filter count
        let completedCount = completedTasks.count //Completed Count
        let completionRate = totalTasks > 0 ? (completedCount * 100) / totalTasks : 0 //Completion Rate
        
        completedLabel.text = "\(completedCount)"
    }
    
    //FilterTasks Method
    private func filterTasks(for filter: StatisticsFilter) -> [TaskModel] {
        //Fetch every tasks
        let allTasks = TaskStorage.shared.getTasks()
        
        switch filter {
            case .weekly: return allTasks.filter { Calendar.current.isDateInThisWeek($0.date) } //Filter weekly basis
            case .monthly: return allTasks.filter { Calendar.current.isDateInThisMonth($0.date) } //Filter monthly basis
            case .yearly: return allTasks.filter { Calendar.current.isDateInThisYear($0.date) } //Filter Yearly basis
            case .all: return allTasks //All tasks
        }
    }
}

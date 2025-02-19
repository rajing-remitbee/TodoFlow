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
    @IBOutlet var completionRateLabel: UILabel!
    
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
        //Filter tasks
        let filteredTasks = filterTasks(for: filter)
        //Filter only completed tasks
        let completedTasks = filteredTasks.filter { $0.isCompleted }
        
        let totalTasks = filteredTasks.count //Filter count
        let completedCount = completedTasks.count //Completed Count
        let completionRate = totalTasks > 0 ? (completedCount * 100) / totalTasks : 0 //Completion Rate
        
        //Format task completed count text
        let fullText = "\(completedCount)/\(totalTasks)" //Full text
        let attributedString = NSMutableAttributedString(string: fullText) //Convert to attributed text
        let completedRange = NSRange(location: 0, length: "\(completedCount)".count) //Calculate range of completed number
        let completedAttributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 36, weight: .semibold), .foregroundColor: UIColor(hex: "#0E100F")] //Apply formatting options
        attributedString.addAttributes(completedAttributes, range: completedRange) //Add attibutes
        let totalRange = NSRange(location: completedRange.length, length: fullText.count - completedRange.length) //Calculate range for total tasks count
        let totalAttributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor(hex: "#7E8491") ] //Apply formatting options
        attributedString.addAttributes(totalAttributes, range: totalRange) //Add attributes
        completedLabel.attributedText = attributedString //Set attributed text
        
        //Format task conversion rate text
        let fullConversionText = "\(completionRate)%" //Full Conversion Rate Text
        let attributedConversionString = NSMutableAttributedString(string: fullConversionText) //Convert to attributed text
        let numberRange = NSRange(location: 0, length: "\(completionRate)".count) //Calculate range of conversion number
        let numberAttributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 36, weight: .semibold), .foregroundColor: UIColor(hex: "#0E100F") ] //Apply formatting options
        attributedConversionString.addAttributes(numberAttributes, range: numberRange) //Add attributes
        let percentRange = NSRange(location: numberRange.length, length: fullConversionText.count - numberRange.length) //Calculate range for percentage symbol
        let percentAttributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor(hex: "#7E8491") ] //Apply formatting options
        attributedConversionString.addAttributes(percentAttributes, range: percentRange) //Add attributes
        completionRateLabel.attributedText = attributedConversionString //Set attributed text
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

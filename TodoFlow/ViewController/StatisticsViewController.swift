//
//  StatisticsViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 18/02/25.
//

import UIKit
import DGCharts

class StatisticsViewController: UIViewController {

    @IBOutlet var filterView: UISegmentedControl! //Segmented Control
    @IBOutlet var completedLabel: UILabel! //Completed Count
    @IBOutlet var completionRateLabel: UILabel! //Completion Rate Label
    @IBOutlet var chartView: HorizontalBarChartView! //ChartView
    @IBOutlet var categoryStatistics: UITableView! //TableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates and Datasource
        categoryStatistics.delegate = self
        categoryStatistics.dataSource = self
        
        //Corner Radius
        filterView.layer.cornerRadius = 10
        
        //Default to Weekly
        filterView.selectedSegmentIndex = 0
        
        //Update for weekly
        updateStatistics(for: .weekly)
        
        //Set-Up Bar Chart
        setUpBarChart()
    }
    
    //Setup Chart
    private func setUpBarChart() {
        chartView.rightAxis.enabled = false  // Hide right Y-axis
        chartView.leftAxis.enabled = false //Hide left Y-axis
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.enabled = true //Enable X-Axis
        chartView.xAxis.granularity = 1 //Set interval to one
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 14, weight: .medium) //Set X-Axis label font
        chartView.xAxis.drawGridLinesEnabled = false //Disable X-Axis grid lines
        chartView.leftAxis.drawGridLinesEnabled = false //Disable Y-Axis grid lines
        chartView.legend.enabled = false //Disable legend
        chartView.drawBarShadowEnabled = false //Disable shadow for bars
        chartView.isUserInteractionEnabled = false //Disable user interaction in graph
        chartView.setExtraOffsets(left: 40, top: 0, right: 0, bottom: 0) //Set extra offsets in left
    }
    
    private func updateChartData( with tasks: [TaskModel]) {
        let categories = getCategoryStatistics()  // Fetch category-wise task stats

        var dataEntries: [BarChartDataEntry] = [] // Data Entries
        var colors: [UIColor] = [] // Bar Colors
        var categoryNames: [String] = [] // Category Names

        for (index, category) in categories.enumerated() {
            //Create a stacked bar with (Completed tasks, Pending tasks)
            let entry = BarChartDataEntry(x: Double(index), yValues: [
                Double(category.completedTasks), //Completed tasks
                Double(category.totalTasks - category.completedTasks) // Pending tasks
            ])
            dataEntries.append(entry) //Add entries
            
            //Set colors: Completed tasks in category color, pending in lighter tone
            colors.append(category.category.color)
            colors.append(category.category.color.withAlphaComponent(0.2)) // Lighter for pending tasks
            
            categoryNames.append(category.category.name) //Set category name
        }

        let dataSet = BarChartDataSet(entries: dataEntries, label: "") //Dataset
        dataSet.colors = colors
        dataSet.stackLabels = ["Pending", "Completed"]
        
        dataSet.drawValuesEnabled = false

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.2
        chartView.data = data
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: categoryNames)
    }
    
    private func getCategoryStatistics() -> [(category: TaskCategoryModel, totalTasks: Int, completedTasks: Int)] {
        let tasks = TaskStorage.shared.getTasks()

        // Group tasks by category
        var categoryStats: [String: (category: TaskCategoryModel, total: Int, completed: Int)] = [:]

        for task in tasks {
            let categoryName = task.category.name
            if categoryStats[categoryName] == nil {
                categoryStats[categoryName] = (task.category, 0, 0)
            }
            categoryStats[categoryName]?.total += 1
            if task.isCompleted {
                categoryStats[categoryName]?.completed += 1
            }
        }

        // Convert dictionary values to the expected return type
        return categoryStats.values.map { ($0.category, $0.total, $0.completed) }
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
        
        updateChartData(with: filteredTasks) //Update chart based on the filter
        
        categoryStatistics.reloadData()
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

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCategoryStatistics().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryStatistics", for: indexPath) as? CategoryStatisticsViewCell else { return UITableViewCell() }
        
        let categories = getCategoryStatistics()
        let categoryData = categories[indexPath.row]
        
        cell.configure(with: categoryData.category, completed: categoryData.completedTasks, total: categoryData.totalTasks)
        
        return cell
    }
}

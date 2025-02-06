//
//  UITableViewDataSource.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 06/02/25.
//

import UIKit

extension MainViewController: UITableViewDataSource {
    
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

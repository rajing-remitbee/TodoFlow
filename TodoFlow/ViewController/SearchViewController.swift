//
//  SearchViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 13/02/25.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var searchView: UISearchBar! //Search Box
    @IBOutlet var searchTableView: UITableView! //Search Table View
    
    
    var tasks: [TaskModel] = [] //Tasks Array
    var categories: [TaskCategoryModel] = [] //Categories Array
    
    var filteredTasks: [TaskModel] = [] //Filtered Tasks Array
    var filteredCategories: [TaskCategoryModel] = [] //Filtered Categories Array
    var isSearching = false //Track searching
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true //Hide navigation back-button
        
        //TableView Delegate & Datasource
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //Fetch tasks and categories from UserDefaults
        tasks = TaskStorage.shared.getTasks()
        categories = CategoryStorage.shared.getCategories()
    }
    
    //Back Button Pressed
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    //SearchBar text Change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //If not searching
        if searchText.isEmpty {
            isSearching = false //Set to false
        } else {
            //Filter tasks and categories based on search text
            isSearching = true
            filteredTasks = tasks.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            filteredCategories = categories.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        //Reload table data
        searchTableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    //Number of Rows in Each Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If searching
        if isSearching == true {
            //Return filtered count
            return section == 0 ? filteredTasks.count : filteredCategories.count
        }
        //Return default count
        return section == 0 ? tasks.count : categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Populate tasks and categories list
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTaskCell", for: indexPath) as! SearchTaskCell //SearchTask UI
            let task = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row] //Fetch task data based on filter
            cell.configure(with: task) //Bind UI and data
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCategoryCell", for: indexPath) as! SearchCategoryCell //SearchCategory UI
            let category = isSearching ? filteredCategories[indexPath.row] : categories[indexPath.row] //Fetch category data based on filter
            cell.configure(with: category) //Bind UI and data
            return cell
        }
    }
    
    //Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //Return section count
    }
    
    //Section Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Tasks Section
        if section == 0 {
            //If no data available hide task heading
            return (isSearching ? filteredTasks.count : tasks.count) > 0 ? "Tasks" : nil
        } else {
            //If no data available hide category heading
            return (isSearching ? filteredCategories.count : categories.count) > 0 ? "Categories" : nil
        }
    }
}

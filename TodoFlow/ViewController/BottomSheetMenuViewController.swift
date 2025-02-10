//
//  BottomSheetMenuViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 10/02/25.
//

import UIKit

class BottomSheetMenuViewController: UIViewController {

    @IBOutlet var categoryTableView: UITableView!
    @IBOutlet var bottomSheetMenuView: UIView!
    
    var taskCategories: [TaskCategoryModel] = []
    var isAddingNewList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        setUpBottomSheet()
        
        setUpCategories()
    }
    
    private func setUpCategories() {
        
        taskCategories = CategoryStorage.shared.getCategories()
        taskCategories.append(TaskCategoryModel(name: "New List", colorHex: "#CCCCCC"))
    }
    
    private func setUpBottomSheet() {
        //Corner Radius
        bottomSheetMenuView.layer.cornerRadius = 16
        //Radius only on top
        bottomSheetMenuView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetMenuView.layer.masksToBounds = true

        // Move bottom sheet off-screen initially
        self.bottomSheetMenuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

        // Animate the bottom sheet sliding up
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetMenuView.transform = .identity
            }
        }
        
        
    }
}

extension BottomSheetMenuViewController: UITableViewDelegate {
    
}

extension BottomSheetMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskCategories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

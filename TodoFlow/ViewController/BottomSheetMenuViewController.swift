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
    @IBOutlet var bottomSheetDragHandle: UIView!
    
    var taskCategories: [TaskCategoryModel] = []
    var isAddingNewList = false
    
    private var initialBottomSheetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Semi-Transparent Background Color
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        //TableView Delegate and Datasource
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        setUpBottomSheet() //Setup Bottomsheet
        setupCategories() //Setup Categories
        addPanGesture()
    }
    
    //Setup BottomSheet
    private func setUpBottomSheet() {
        //Corner Radius
        bottomSheetMenuView.layer.cornerRadius = 16
        //Radius only on top
        bottomSheetMenuView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetMenuView.layer.masksToBounds = true
        
        //Drag-Handle Radius
        bottomSheetDragHandle.layer.cornerRadius = 2

        // Move bottom sheet off-screen initially
        self.bottomSheetMenuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)

        // Animate the bottom sheet sliding up
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetMenuView.transform = .identity
            }
        }
    }
    
    //Fetch and Set CategoryList
    private func setupCategories() {
        taskCategories = CategoryStorage.shared.getCategories() //Fetch Categories
        taskCategories.append(TaskCategoryModel(name: "Add New List", colorHex: "#00A86B")) //Add new list menu
    }
    
    //Add Pan Gesture
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))) //Setup PanGesture
        bottomSheetMenuView.addGestureRecognizer(panGesture) //Add PanGesture to BottomSheet
    }
    
    //Handle Pan Gesture
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        //BottomSheet XY Translation
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
            //Initial BottomSheet State
        case .began:
            initialBottomSheetY = bottomSheetMenuView.frame.origin.y
            //Changed BottomSheet State
        case .changed:
            let newY = initialBottomSheetY + translation.y
            if newY >= initialBottomSheetY {
                // Prevent moving up beyond original position
                bottomSheetMenuView.frame.origin.y = newY
            }
            //Final BottomSheet State
        case .ended:
            //Gesture Velocity
            let velocity = gesture.velocity(in: view)
            if velocity.y > 500 {
                // If swipe down fast, dismiss
                dismissBottomSheet()
            } else {
                // Snap back to original position if not swiped hard enough
                UIView.animate(withDuration: 0.3) {
                    self.bottomSheetMenuView.transform = .identity
                }
            }
        default:
            break
        }
    }
   
    //Dismiss the Bottom Sheet
    private func dismissBottomSheet() {
        //Dismiss Animation
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetMenuView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
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
        return taskCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = taskCategories[indexPath.row]
        
        cell.categoryLabel.text = category.name
        cell.categoryBox.layer.borderWidth = 1
        cell.categoryBox.layer.borderColor = category.color.cgColor
        
        return cell
    }
    
    
}

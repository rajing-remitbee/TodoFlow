//
//  ViewController.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 05/02/25.
//

import UIKit

class MainViewController: UIViewController {
    
    var dates: [Date] = []
    
    @IBOutlet var profileImageView: UIImageView! //ProfileImageView Component
    @IBOutlet var dataCollectionView: UICollectionView! //CollectionView Component

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ProfileView - Corner Radius
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        //CollectionView Data and Delegate Sources
        dataCollectionView.delegate = self
        dataCollectionView.dataSource = self
        
        generateDates()
        
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
        
        dataCollectionView.reloadData()
    }

}


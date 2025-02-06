//
//  UICollectionViewDataSource.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 05/02/25.
//

import UIKit

extension MainViewController: UICollectionViewDataSource {
    
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
    
    
}

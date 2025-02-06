//
//  UICollectionViewDelegate.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 05/02/25.
//

import UIKit

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDate = dates[indexPath.row]
        
        // Find the section index for the selected date
        if let sectionIndex = taskSection.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) {
            let indexPath = IndexPath(row: 0, section: sectionIndex)
            taskTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

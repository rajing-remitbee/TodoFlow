//
//  DateCollectionViewCell.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 05/02/25.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var dayLabel: UILabel! //Day Label
    @IBOutlet var dateLabel: UILabel! //Date Label

    //Prepare for displaying
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8 //Corner Radius
        self.layer.borderWidth = 1 //Border Width
        self.layer.borderColor = UIColor.lightGray.cgColor //Border Color
    }
    
    func configure(with date: Date, isToday: Bool, isPast: Bool) {
        //Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        dateLabel.text = dateFormatter.string(from: date)
        
        //Format Day
        dateFormatter.dateFormat = "E"
        dayLabel.text = dateFormatter.string(from: date)
        
        if isToday {
            //If date is Today, Show in green color
            dayLabel.textColor = .green
            dateLabel.textColor = .green
        } else if isPast {
            //If date is past, Show in grey color
            dayLabel.textColor = .gray
            dateLabel.textColor = .gray
        } else {
            //If date is upcoming, Show in black color
            dayLabel.textColor = .black
            dateLabel.textColor = .black
        }
        
    }
    
    
    
}

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
    //Indicator for today's date
    private let indicatorView = UIView()

    //Prepare for displaying
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the indicator view
        indicatorView.backgroundColor = UIColor(hex: "#00A86B") // Custom green color
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorView)
        
        // Set constraints to position the indicator at the bottom center
        NSLayoutConstraint.activate([
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),  // Attach to bottom
            indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),  // Attach to left
            indicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),  // Attach to right
            indicatorView.heightAnchor.constraint(equalToConstant: 4)  // Height of the line
        ])
        
        //Hide indicator initially
        indicatorView.isHidden = true
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
            //Check for Today
            let todayColor = UIColor(hex: "#00A86B")
            dayLabel.textColor = todayColor
            dateLabel.textColor = todayColor
            indicatorView.isHidden = false
        } else if isPast {
            //Check for past date
            dayLabel.textColor = UIColor(hex: "#C0C3C9")
            dateLabel.textColor = UIColor(hex: "#C0C3C9")
            indicatorView.isHidden = true
        } else {
            //Upcoming date
            dayLabel.textColor = UIColor(hex: "#0E100F")
            dateLabel.textColor = UIColor(hex: "#0E100F")
            indicatorView.isHidden = true
        }
    }
}

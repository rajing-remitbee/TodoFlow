//
//  Calendar.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 18/02/25.
//

import Foundation

extension Calendar {
    
    //Check date is in the week
    func isDateInThisWeek(_ date: Date) -> Bool {
        guard let startOfWeek = self.dateInterval(of: .weekOfYear, for: Date())?.start else { return false } //Start of week
        let endOfWeek = self.date(byAdding: .day, value: 6, to: startOfWeek)! //End of the week
        let status = (startOfWeek...endOfWeek).contains(date) //Check if exists
        return status //Return value
    }

    //Check date is in the month
    func isDateInThisMonth(_ date: Date) -> Bool {
        guard let startOfMonth = self.dateInterval(of: .month, for: Date())?.start else { return false } //Start of month
        let endOfMonth = self.date(byAdding: .month, value: 1, to: startOfMonth)! //End of month
        let status = (startOfMonth..<endOfMonth).contains(date) //Check if exists
        return status //Return value
    }

    //Check date is in the year
    func isDateInThisYear(_ date: Date) -> Bool {
        guard let startOfYear = self.dateInterval(of: .year, for: Date())?.start else { return false } //Start of year
        let endOfYear = self.date(byAdding: .year, value: 1, to: startOfYear)! //End of year
        let status = (startOfYear..<endOfYear).contains(date) //Check if exists
        return status //Return value
    }
}

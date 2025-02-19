//
//  Calendar.swift
//  TodoFlow
//
//  Created by Rajin Gangadharan on 18/02/25.
//

import Foundation

extension Calendar {
    func isDateInThisWeek(_ date: Date) -> Bool {
        guard let startOfWeek = self.dateInterval(of: .weekOfYear, for: Date())?.start else { return false }
        let endOfWeek = self.date(byAdding: .day, value: 6, to: startOfWeek)!
        let status = (startOfWeek...endOfWeek).contains(date)
        return status
    }

    func isDateInThisMonth(_ date: Date) -> Bool {
        guard let startOfMonth = self.dateInterval(of: .month, for: Date())?.start else { return false }
        let endOfMonth = self.date(byAdding: .month, value: 1, to: startOfMonth)!
        let status = (startOfMonth..<endOfMonth).contains(date)
        return status
    }

    func isDateInThisYear(_ date: Date) -> Bool {
        guard let startOfYear = self.dateInterval(of: .year, for: Date())?.start else { return false }
        let endOfYear = self.date(byAdding: .year, value: 1, to: startOfYear)!
        let status = (startOfYear..<endOfYear).contains(date)
        return status
    }
}

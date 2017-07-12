//
//  CalendarHelper.swift
//  Mom's Accountant
//
//  Created by Calvin Gonçalves de Aquino on 7/11/17.
//  Copyright © 2017 Calvin. All rights reserved.
//

import Foundation

struct CalendarHelper {
    static func monthNameFromDate(_ date: Date) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        let monthNames = calendar.monthSymbols
        let monthIndex = calendar.component(.month, from: date)
        
        return monthNames[monthIndex]
    }
    
    static func monthNameFromNumber(_ monthNumber: Int) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        let monthNames = calendar.monthSymbols
        
        return monthNames[monthNumber]
    }
    
    static func monthIndexFromDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: date)
    }
    
    static func yearNumberFromDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
}

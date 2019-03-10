//
//  DateCellState.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 23.02.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import Foundation

public class DateCellState {
    
    public let date: Date
    public let dateText: String
    public let monthText: String
    public let hasAlternatingColor: Bool
    
    static let `default`: DateCellState = DateCellState(date: Date(), dateText: "", monthText: "", hasAlternatingColor: false)
    
    init(date: Date, dateText: String, monthText: String, hasAlternatingColor: Bool) {
        self.date = date
        self.dateText = dateText
        self.monthText = monthText
        self.hasAlternatingColor = hasAlternatingColor
    }
}

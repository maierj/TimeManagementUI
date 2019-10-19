//
//  CalendarViewControllerConfiguration.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 23.02.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import Foundation
import UIKit

public struct CalendarViewControllerConfiguration {
    
    public enum DateSelectionMode {
        case none, single(allowsMultipleSingleSelections: Bool), range(allowsMultipleRangeSelections: Bool)
    }

    public enum StartOfWeek {
        case sunday, monday
    }

    let startDate: Date
    let endDate: Date
    let dateCellStyleProvider: DateCellStyleProvider
    let selectionMode: DateSelectionMode
    let startOfWeek: StartOfWeek
    
    public init(
            startDate: Date,
            endDate: Date,
            dateCellStyleProvider: DateCellStyleProvider,
            selectionMode: DateSelectionMode,
            startOfWeek: StartOfWeek = .monday
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.dateCellStyleProvider = dateCellStyleProvider
        self.selectionMode = selectionMode
        self.startOfWeek = startOfWeek

        if endDate.timeIntervalSince(startDate) < 0 {
            fatalError("Calendar start date has to be before end date.")
        }
    }
}

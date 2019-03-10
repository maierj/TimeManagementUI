//
//  CalendarViewControllerConfiguration.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 23.02.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import Foundation
import UIKit

struct CalendarViewControllerConfiguration {
    
    enum DateSelectionMode {
        case none, single(allowsMultipleSingleSelections: Bool), range(allowsMultipleRangeSelections: Bool)
    }
    
    let dateCellStyleProvider: DateCellStyleProvider
    let selectionMode: DateSelectionMode
}

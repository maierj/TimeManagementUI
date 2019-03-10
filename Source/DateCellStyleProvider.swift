//
//  DateCellStyle.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 23.02.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import Foundation
import UIKit

public enum DateCellSelectionCornerStyle {
    case rectangular, rounded
}

public protocol DateCellStyleProvider {
    
    var alternatingMonthBackgroundColor1: UIColor { get }
    var alternatingMonthBackgroundColor2: UIColor { get }
    
    func applyDefaultStyle(to cell: DateCollectionCell)
    func applySingleSelectionStyle(to cell: DateCollectionCell)
    func applyRangeSelectionStartStyle(to cell: DateCollectionCell)
    func applyRangeSelectionMiddleStyle(to cell: DateCollectionCell)
    func applyRangeSelectionEndStyle(to cell: DateCollectionCell)
}

public extension DateCellStyleProvider {
    
    var alternatingMonthBackgroundColor1: UIColor {
        return .white
    }
    
    var alternatingMonthBackgroundColor2: UIColor {
        return .lightGray
    }
}

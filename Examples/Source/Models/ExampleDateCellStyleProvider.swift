//
//  ExampleDateCellStyleProvider.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 09.03.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import Foundation

struct ExampleDateCellStyleProvider: DateCellStyleProvider {
    
    func applyDefaultStyle(to cell: DateCollectionCell) {
        cell.backgroundColor = cell.state.hasAlternatingColor ? self.alternatingMonthBackgroundColor2 : self.alternatingMonthBackgroundColor1
        cell.monthLabel.textColor = .black
        cell.dateLabel.textColor = .black
        cell.selectionIndicator.backgroundColor = cell.backgroundColor
        cell.selectionIndicator.layer.cornerRadius = 0.0
    }
    
    func applySingleSelectionStyle(to cell: DateCollectionCell) {
        cell.backgroundColor = cell.state.hasAlternatingColor ? self.alternatingMonthBackgroundColor2 : self.alternatingMonthBackgroundColor1
        cell.monthLabel.textColor = .white
        cell.dateLabel.textColor = .white
        cell.selectionIndicator.backgroundColor = .blue
        cell.selectionIndicator.layer.cornerRadius = cell.contentView.frame.width / 2.0
    }
    
    func applyRangeSelectionStartStyle(to cell: DateCollectionCell) {
        cell.backgroundColor = cell.state.hasAlternatingColor ? self.alternatingMonthBackgroundColor2 : self.alternatingMonthBackgroundColor1
        cell.monthLabel.textColor = .white
        cell.dateLabel.textColor = .white
        cell.selectionIndicator.backgroundColor = .blue
        cell.selectionIndicator.layer.cornerRadius = cell.contentView.frame.width / 2.0
    }
    
    func applyRangeSelectionMiddleStyle(to cell: DateCollectionCell) {
        cell.backgroundColor = cell.state.hasAlternatingColor ? self.alternatingMonthBackgroundColor2 : self.alternatingMonthBackgroundColor1
        cell.monthLabel.textColor = .white
        cell.dateLabel.textColor = .white
        cell.selectionIndicator.backgroundColor = .blue
        cell.selectionIndicator.layer.cornerRadius = 0
    }
    
    func applyRangeSelectionEndStyle(to cell: DateCollectionCell) {
        cell.backgroundColor = cell.state.hasAlternatingColor ? self.alternatingMonthBackgroundColor2 : self.alternatingMonthBackgroundColor1
        cell.monthLabel.textColor = .white
        cell.dateLabel.textColor = .white
        cell.selectionIndicator.backgroundColor = .blue
        cell.selectionIndicator.layer.cornerRadius = cell.contentView.frame.width / 2.0
    }
}

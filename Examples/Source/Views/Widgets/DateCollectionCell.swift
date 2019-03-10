//
//  DateCollectionCell.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 21.02.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import Foundation
import UIKit

class DateCollectionCell: UICollectionViewCell {
    
    let selectionIndicator: UIView
    
    let monthLabel: UILabel
    let dateLabel: UILabel
    
    var state: DateCellState
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        
        set {
            super.isSelected = newValue
        }
    }
    
    override init(frame: CGRect) {
        selectionIndicator = UIView()
        monthLabel = UILabel()
        dateLabel = UILabel()
        state = .default
        
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupSubviews()
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        monthLabel.font = UIFont.systemFont(ofSize: 10)
    }
    
    private func addSubviews() {
        contentView.addSubview(selectionIndicator)
        selectionIndicator.addSubview(monthLabel)
        selectionIndicator.addSubview(dateLabel)
    }
    
    private func setupLayoutConstraints() {
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectionIndicator.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            selectionIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            monthLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -2),
            monthLabel.centerXAnchor.constraint(equalTo: selectionIndicator.centerXAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: selectionIndicator.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: selectionIndicator.centerYAnchor)
        ])
    }
    
    func apply(state: DateCellState) {
        self.state = state
        
        monthLabel.text = state.monthText
        dateLabel.text = state.dateText
    }
}

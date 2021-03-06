//
//  ViewController.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 21.02.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import UIKit
import TimeManagementUI 

class MainViewController: UIViewController {
    
    let calendarVC: CalendarViewController
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    init() {
        let calendarViewControllerConfiguration = CalendarViewControllerConfiguration(
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: DateComponents(year: 1), to: Date())!,
            dateCellStyleProvider: ExampleDateCellStyleProvider(),
            selectionMode: .range(allowsMultipleRangeSelections: true),
            startOfWeek: .monday
        )
        calendarVC = CalendarViewController(configuration: calendarViewControllerConfiguration)
        
        super.init(nibName: nil, bundle: nil)
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addChild(calendarVC)
        view.addSubview(calendarVC.view)
    }
    
    private func setupLayoutConstraints() {
        calendarVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            calendarVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

//
//  CalendarView.swift
//  TimeManagementUIExamples
//
//  Created by Jonas Maier on 21.02.19.
//  Copyright © 2019 Jonas Maier. All rights reserved.
//

import Foundation
import UIKit

public class CalendarViewController: UIViewController {

    /// The configuration that is currently applied to the CalendarViewController
    private let configuration: CalendarViewControllerConfiguration
    
    private let weekdaysHeaderView = WeekdaysHeaderView()

    /// The main collection view that presents all date cells
    private let collectionView: UICollectionView

    /**
        The view that is visible if the range editing mode by dragging is active,
        displays the date of the cell over which the drag is taking place
    */
    private let dateMagnifierView = DateCellMagnifierView()

    /// The constraint that is used to position dateMagnifierView according to the current vertical drag position
    private var dateMagnifierBottomTopOffset: NSLayoutConstraint?

    /// The constraint that is used to position dateMagnifierView according to the current horizontal drag position
    private var dateMagnifierCenterLeftOffset: NSLayoutConstraint?
    
    fileprivate static let cellReuseIdentifier = "DateCollectionCell"
    fileprivate let firstOfMonthOfStartDate: Date
    fileprivate let calendar = Calendar.current
    fileprivate let startDateIndexOffset: Int

    private var selectedItemIndexes = Set<Int>()
    
    fileprivate let monthFormatter: DateFormatter = {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        return monthFormatter
    }()
    
    fileprivate let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    fileprivate let dateMagnifierFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()

    /// The recognizer that is used to detect and perform a range editing action by dragging
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()

    /// The feedback generator that is used to signal the start of a range editing action by dragging
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator()

    /// The feedback generator that is used to signal a change in the range during a range editing action by dragging
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    private var dragSessionFixedItemIndex: Int?
    private var dragSessionLastItemIndex: Int?
    
    public init(configuration: CalendarViewControllerConfiguration) {
        self.configuration = configuration
        
        let flowLayout = CalendarLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        let startDateWeekdayComponent = calendar.dateComponents([.weekday], from: configuration.startDate)
        startDateIndexOffset = startDateWeekdayComponent.weekday! - (configuration.startOfWeek == .monday ? 2 : 1)
        
        let components = calendar.dateComponents([.year, .month], from: configuration.startDate)
        firstOfMonthOfStartDate = calendar.date(from: components)!
        
        super.init(nibName: nil, bundle: nil)
        
        if case .range = configuration.selectionMode {
            longPressGestureRecognizer.addTarget(self, action: #selector(handleLongPress(gestureRecognizer:)))
            longPressGestureRecognizer.minimumPressDuration = 0.5
            
            collectionView.addGestureRecognizer(longPressGestureRecognizer)
        }
        
        setupSubviews()
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCollectionCell.self, forCellWithReuseIdentifier: CalendarViewController.cellReuseIdentifier)
    
        switch configuration.selectionMode {
        case .none:
            collectionView.allowsSelection = false
        case .single(let allowsMultipleSingleSelections):
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = allowsMultipleSingleSelections
        case .range:
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = true
        }
        
        dateMagnifierView.isHidden = true
    }
    
    private func addSubviews() {
        view.addSubview(weekdaysHeaderView)
        view.addSubview(collectionView)
        view.addSubview(dateMagnifierView)
    }
    
    private func setupLayoutConstraints() {
        weekdaysHeaderView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        dateMagnifierView.translatesAutoresizingMaskIntoConstraints = false
        
        dateMagnifierBottomTopOffset = dateMagnifierView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0)
        dateMagnifierCenterLeftOffset = dateMagnifierView.centerXAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            weekdaysHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            weekdaysHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weekdaysHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: weekdaysHeaderView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateMagnifierBottomTopOffset!,
            dateMagnifierCenterLeftOffset!
        ])
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let position = gestureRecognizer.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: position),
            let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems else {
            return
        }
        
        if gestureRecognizer.state == .began {
            let dragStartCellSelectionMode = getSelectionMode(at: indexPath)
            
            if dragStartCellSelectionMode == .rangeStart || dragStartCellSelectionMode == .rangeEnd || dragStartCellSelectionMode == .single {
                impactFeedbackGenerator.prepare()
                impactFeedbackGenerator.impactOccurred()
                
                if let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionCell {
                    dateMagnifierBottomTopOffset?.constant = position.y - 25 - collectionView.contentOffset.y
                    dateMagnifierCenterLeftOffset?.constant = position.x
                    dateMagnifierView.dateLabel.text = dateMagnifierFormatter.string(from: cell.state.date)
                }
            
                dateMagnifierView.isHidden = false
                
                if dragStartCellSelectionMode == .single {
                    dragSessionFixedItemIndex = indexPath.item
                } else {
                    let iterationChangeValue = dragStartCellSelectionMode == .rangeStart ? 1 : -1
                    var rangeItemIndex = indexPath.item
                    repeat {
                        rangeItemIndex += iterationChangeValue
                    } while indexPathsForSelectedItems.contains(IndexPath(item: rangeItemIndex, section: indexPath.section))
                    
                    dragSessionFixedItemIndex = rangeItemIndex - iterationChangeValue
                }
            }
        } else if gestureRecognizer.state == .changed {
            guard let dragSessionFixedItemIndex = dragSessionFixedItemIndex,
                let dragSessionLastItemIndex = dragSessionLastItemIndex else {
                return
            }
            
            dateMagnifierBottomTopOffset?.constant = position.y - 25 - collectionView.contentOffset.y
            dateMagnifierCenterLeftOffset?.constant = position.x
            
            if let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionCell {
                dateMagnifierView.dateLabel.text = dateMagnifierFormatter.string(from: cell.state.date)
            }
            
            if indexPath.item != dragSessionLastItemIndex {
                selectionFeedbackGenerator.selectionChanged()
                
                if dragSessionFixedItemIndex < indexPath.item {
                    if indexPath.item >= dragSessionLastItemIndex {
                        if dragSessionFixedItemIndex > dragSessionLastItemIndex {
                            deselectItems(from: dragSessionLastItemIndex, to: dragSessionFixedItemIndex)
                            selectItems(from: dragSessionFixedItemIndex, to: indexPath.item)
                        } else {
                            selectItems(from: dragSessionLastItemIndex, to: indexPath.item)
                        }
                    } else {
                        deselectItems(from: indexPath.item + 1, to: dragSessionLastItemIndex)
                    }
                } else {
                    if indexPath.item <= dragSessionLastItemIndex {
                        if dragSessionFixedItemIndex < dragSessionLastItemIndex {
                            deselectItems(from: dragSessionFixedItemIndex, to: dragSessionLastItemIndex)
                            selectItems(from: dragSessionFixedItemIndex, to: indexPath.item)
                        } else {
                            selectItems(from: dragSessionLastItemIndex, to: indexPath.item)
                        }
                    } else {
                        deselectItems(from: dragSessionLastItemIndex, to: indexPath.item - 1)
                    }
                }
            }
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled || gestureRecognizer.state == .failed {
            dateMagnifierView.isHidden = true
            dragSessionLastItemIndex = nil
            dragSessionFixedItemIndex = nil
        }
        
        dragSessionLastItemIndex = indexPath.item
    }
    
    private func selectItems(from startItemIndex: Int, to endItemIndex: Int) {
        debugPrint("selectItems(from: \(startItemIndex), to: \(endItemIndex))")

        let ascendingIteration = startItemIndex <= endItemIndex
        
        for itemIndex in stride(from: startItemIndex, through: endItemIndex, by: ascendingIteration ? 1 : -1) {
            if !selectedItemIndexes.contains(itemIndex) {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
            }
        }
    }
    
    private func deselectItems(from startItemIndex: Int, to endItemIndex: Int) {
        debugPrint("deselectItems(from: \(startItemIndex), to: \(endItemIndex))")

        for itemIndex in startItemIndex...endItemIndex {
            if selectedItemIndexes.contains(itemIndex) {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                collectionView.deselectItem(at: indexPath, animated: false)
                collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
            }
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of days between start and end date of the configuration
        return Int(ceil(configuration.endDate.timeIntervalSince(configuration.startDate) / (60.0 * 60.0 * 24.0)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewController.cellReuseIdentifier, for: indexPath) as? DateCollectionCell else {
            fatalError("Could not dequeue reusable cell for reuse identifier \(CalendarViewController.cellReuseIdentifier).")
        }
        
        if indexPath.item >= startDateIndexOffset {
            let startDateOffset = indexPath.item - startDateIndexOffset
            let dayIncrementComponent = DateComponents(day: startDateOffset)
            
            guard let cellDate = calendar.date(byAdding: dayIncrementComponent, to: configuration.startDate) else {
                fatalError("Could not calculate cell date by adding \(startDateOffset) days to start date.")
            }

            let differenceComponents = calendar.dateComponents([.month, .day], from: firstOfMonthOfStartDate, to: cellDate)
            let daysOffset = differenceComponents.day!
            let monthOffset = differenceComponents.month!
            
            let isStartOfMonth = daysOffset == 0
            let isEvenMonth = monthOffset % 2 == 0
            
            let cellState = DateCellState(
                date: cellDate,
                dateText: dateFormatter.string(from: cellDate),
                monthText: isStartOfMonth ? monthFormatter.string(from: cellDate) : "",
                hasAlternatingColor: !isEvenMonth
            )
            
            dateCell.apply(state: cellState)
        } else {
            dateCell.apply(state: .default)
        }
        
        applyStyle(to: dateCell, at: indexPath)
        
        return dateCell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let standardColumnWidth = floor(view.frame.width / 7.0)
        let lastColumnWidth = view.frame.width - standardColumnWidth * 6.0
        
        if (indexPath.item + 1) % 7 == 0 {
            return CGSize(width: lastColumnWidth, height: standardColumnWidth)
        } else {
            return CGSize(width: standardColumnWidth, height: standardColumnWidth)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems else {
            return
        }

        selectedItemIndexes.insert(indexPath.item)
        
        if case .range(let allowsMultipleRangeSelections) = configuration.selectionMode,
            !allowsMultipleRangeSelections,
            indexPathsForSelectedItems.count > 1 {
            let precedingItemIndex = indexPath.item - 1
            let followingItemIndex = indexPath.item + 1

            if !indexPathsForSelectedItems.contains(IndexPath(item: precedingItemIndex, section: 0)),
                !indexPathsForSelectedItems.contains(IndexPath(item: followingItemIndex, section: 0)) {
                indexPathsForSelectedItems
                    .filter {
                        $0 != indexPath
                    }
                    .forEach { selectedIndexPath in
                        collectionView.deselectItem(at: selectedIndexPath, animated: false)
                        collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: selectedIndexPath)
                    }
            }

            collectionView.indexPathsForSelectedItems?.forEach { selectedIndexPath in
                if let cell = collectionView.cellForItem(at: selectedIndexPath) as? DateCollectionCell {
                    applyStyle(to: cell, at: selectedIndexPath)
                }
            }
        } else {
            applyStyleToCellAndImmediateNeighbours(at: indexPath, in: collectionView)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        applyStyleToCellAndImmediateNeighbours(at: indexPath, in: collectionView)

        selectedItemIndexes.remove(indexPath.item)
    }

    private func applyStyleToCellAndImmediateNeighbours(at indexPath: IndexPath, in collectionView: UICollectionView) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionCell {
            applyStyle(to: cell, at: indexPath)
        }

        let precedingItemIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let followingItemIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)

        if let precedingCell = collectionView.cellForItem(at: precedingItemIndexPath) as? DateCollectionCell {
            applyStyle(to: precedingCell, at: precedingItemIndexPath)
        }

        if let followingCell = collectionView.cellForItem(at: followingItemIndexPath) as? DateCollectionCell {
            applyStyle(to: followingCell, at: followingItemIndexPath)
        }
    }
    
    private func applyStyle(to cell: DateCollectionCell, at indexPath: IndexPath) {
        switch getSelectionMode(at: indexPath) {
        case .none:
            configuration.dateCellStyleProvider.applyDefaultStyle(to: cell)
        case .single:
            configuration.dateCellStyleProvider.applySingleSelectionStyle(to: cell)
        case .rangeStart:
            configuration.dateCellStyleProvider.applyRangeSelectionStartStyle(to: cell)
        case .rangeMiddle:
            configuration.dateCellStyleProvider.applyRangeSelectionMiddleStyle(to: cell)
        case .rangeEnd:
            configuration.dateCellStyleProvider.applyRangeSelectionEndStyle(to: cell)
        }
    }
    
    private func getSelectionMode(at indexPath: IndexPath) -> DateCellSelectionMode {
        if let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems, indexPathsForSelectedItems.contains(indexPath) {
            let precedingItemIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
            let followingItemIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            
            if indexPathsForSelectedItems.contains(precedingItemIndexPath) {
                if indexPathsForSelectedItems.contains(followingItemIndexPath) {
                    // Range selection middle
                    return .rangeMiddle
                } else {
                    // Range selection end
                    return .rangeEnd
                }
            } else {
                if indexPathsForSelectedItems.contains(followingItemIndexPath) {
                    // Range selection start
                    return .rangeStart
                } else {
                    // Single selection
                    return .single
                }
            }
        } else {
            return .none
        }
    }
}

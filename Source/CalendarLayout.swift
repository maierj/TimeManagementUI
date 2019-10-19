//
// Created by Jonas Maier on 2019-03-16.
// Copyright (c) 2019 Jonas Maier. All rights reserved.
//

import UIKit

final class CalendarLayout: UICollectionViewFlowLayout {

    override public func prepare() {
        super.prepare()
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)
    }
}

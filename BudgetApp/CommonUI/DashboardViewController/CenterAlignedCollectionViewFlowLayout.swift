import UIKit

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() as! UICollectionViewLayoutAttributes }) else {
            return nil
        }

        var rows: [[UICollectionViewLayoutAttributes]] = []
        var currentRowY: CGFloat = -1
        var currentRow: [UICollectionViewLayoutAttributes] = []

        for attr in attributes where attr.representedElementCategory == .cell {
            if abs(attr.frame.origin.y - currentRowY) > 1 {
                if !currentRow.isEmpty {
                    rows.append(currentRow)
                }
                currentRow = [attr]
                currentRowY = attr.frame.origin.y
            } else {
                currentRow.append(attr)
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        for row in rows {
            let totalWidth = row.reduce(0) { $0 + $1.frame.width } +
                             CGFloat(row.count - 1) * minimumInteritemSpacing
            let collectionViewWidth = collectionView?.bounds.width ?? 0
            let leftInset = max((collectionViewWidth - totalWidth) / 2, sectionInset.left)

            var xOffset = leftInset
            for attr in row {
                attr.frame.origin.x = xOffset
                xOffset += attr.frame.width + minimumInteritemSpacing
            }
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

//
//  SpecialServiceCell.swift
//  avito1
//
//  Created by Mikhail Sergeev on 03.01.2021.
//

import UIKit

class SpecialServiceCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    static let identifier = "SpecialServiceCell"
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var newTargetSize = targetSize
        newTargetSize.height = CGFloat.greatestFiniteMagnitude
               let newSize = super.systemLayoutSizeFitting(newTargetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        return newSize
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        checkmarkImageView.image = nil
    }
    
}

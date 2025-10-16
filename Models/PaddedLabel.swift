//
//  Padded Label.swift
//  sahibindenVitrin
//
//  Created by Ibrahim Alperen Kurum on 9.10.2025.
//
import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }

    override var bounds: CGRect {
        didSet {
            // Ensure preferredMaxLayoutWidth updates correctly for multi-line labels
            preferredMaxLayoutWidth = bounds.width - (textInsets.left + textInsets.right)
        }
    }
}

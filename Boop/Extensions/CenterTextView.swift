//
//  CenterTextView.swift
//  Boop
//
//  Created by Sam Gehly on 3/5/18.
//  Copyright © 2018 Sam Gehly. All rights reserved.
//

import Foundation
import UIKit

class VerticallyCenteredTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}

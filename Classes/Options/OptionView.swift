//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import UIKit

/// A view that contains a button and handles image layout
final class OptionView: UIView {

    private(set) var button: ExtendedButton
    private let inset: CGFloat
    
    /// The designated initializer for an OptionView, it can accept an `inset` value for a larger tap area
    ///
    /// - Parameters:
    ///   - image: image to describe the option
    ///   - inset: use a negative value to "outset"
    init(image: UIImage?, inset: CGFloat = 0) {
        self.inset = inset
        button = ExtendedButton(inset: inset)
        button.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.applyShadows()
        super.init(frame: .zero)
        setUpButton()
    }

    @available(*, unavailable, message: "use init(image:) instead")
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable, message: "use init(image:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
    
    private func setUpButton() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            button.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            button.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor),
            safeLayoutGuide.heightAnchor.constraint(equalTo: safeLayoutGuide.widthAnchor)
            ])
    }
}
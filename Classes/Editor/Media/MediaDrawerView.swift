//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import UIKit

/// Constants for MediaDrawerView
private struct Constants {
    static let animationDuration: TimeInterval = 0.25
    static let topContainerHeight: CGFloat = 52
    static let topContainerCornerRadius: CGFloat = 30
    static let topContainerLineHeight: CGFloat = 5
    static let topContainerLineWidth: CGFloat = 36
    static let topContainerLineRadius: CGFloat = 36
    static let topContainerLineColor: UIColor = .black
    static let backgroundColor: UIColor = .white
    static let bottomBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    static let tabBarHeight: CGFloat = DrawerTabBarView.height
}

/// A UIView for the media drawer view
final class MediaDrawerView: UIView {
    
    static let tabBarHeight: CGFloat = Constants.tabBarHeight
    
    private let topContainer: UIView
    private let topContainerLine: UIView
    private let backPanel: UIView
    
    // Containers
    let tabBarContainer: UIView
    let childContainer: UIView
    
    // MARK: - Initializers
    
    init() {
        topContainer = UIView()
        topContainerLine = UIView()
        backPanel = UIView()
        tabBarContainer = UIView()
        childContainer = UIView()
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable, message: "use init() instead")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupChildContainer()
        setupBackPanel()
        setupTopContainer()
        setupTopContainerLine()
        setupTabBar()
    }
    
    /// Sets up the container for the new view after a tab is selected
    private func setupChildContainer() {
        addSubview(childContainer)
        childContainer.accessibilityLabel = "Media Drawer Child Container"
        childContainer.translatesAutoresizingMaskIntoConstraints = false
        childContainer.backgroundColor = Constants.bottomBackgroundColor
        childContainer.clipsToBounds = false
        
        NSLayoutConstraint.activate([
            childContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topContainerHeight + Constants.tabBarHeight),
            childContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            childContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            childContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupBackPanel() {
        addSubview(backPanel)
        backPanel.accessibilityLabel = "Media Drawer Back Panel"
        backPanel.backgroundColor = Constants.backgroundColor
        backPanel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backPanel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topContainerHeight / 2),
            backPanel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backPanel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backPanel.heightAnchor.constraint(equalToConstant: Constants.topContainerHeight / 2),
        ])
    }
    
    /// Sets up the top view with rounded corners
    private func setupTopContainer() {
        addSubview(topContainer)
        topContainer.accessibilityLabel = "Media Drawer Top Container"
        topContainer.backgroundColor = Constants.backgroundColor
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: Constants.topContainerHeight),
        ])
        
        topContainer.layer.cornerRadius = Constants.topContainerCornerRadius
        topContainer.layer.masksToBounds = true
    }
    
    /// Sets up the small black line with rounded ends in the top view
    private func setupTopContainerLine() {
        topContainer.addSubview(topContainerLine)
        topContainerLine.accessibilityLabel = "Media Drawer Top Container Line"
        topContainerLine.backgroundColor = Constants.topContainerLineColor
        topContainerLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topContainerLine.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            topContainerLine.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            topContainerLine.heightAnchor.constraint(equalToConstant: Constants.topContainerLineHeight),
            topContainerLine.widthAnchor.constraint(equalToConstant: Constants.topContainerLineWidth),
        ])
        
        topContainerLine.layer.cornerRadius = 2.5
        topContainerLine.layer.masksToBounds = true
    }
    
    /// Sets up the top tab bar
    private func setupTabBar() {
        addSubview(tabBarContainer)
        tabBarContainer.accessibilityLabel = "Media Drawer Tab Bar Container"
        tabBarContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabBarContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topContainerHeight),
            tabBarContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tabBarContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tabBarContainer.heightAnchor.constraint(equalToConstant: Constants.tabBarHeight),
        ])
    }
}

//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Арина Колганова on 16.03.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = Assembly().trackerCoordinator().make()!

        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

    func testViewControllerDarkTheme() {
        let vc = Assembly().trackerCoordinator().make()!

        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}

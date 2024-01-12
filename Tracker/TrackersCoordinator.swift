//
//  TrackersCoordinator.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

final class TrackersCoordinator: BaseCoordinator<TrackersCoordinator.Context> {
    struct Context {}

    override func make() -> UIViewController? {
        assembly.trackerVC()
    }
}

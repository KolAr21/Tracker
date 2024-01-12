//
//  TrackersAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import Foundation

protocol TrackersAssembly {
    func trackerCoordinator() -> TrackersCoordinator
    func trackerVC() -> TrackersViewController<TrackersViewImp>
}

extension Assembly: TrackersAssembly {
    func trackerCoordinator() -> TrackersCoordinator {
        TrackersCoordinator(assembly: self, context: .init())
    }

    func trackerVC() -> TrackersViewController<TrackersViewImp> {
        .init()
    }
}

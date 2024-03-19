//
//  StatisticAssembly.swift
//  Tracker
//
//  Created by Арина Колганова on 12.01.2024.
//

import UIKit

protocol StatisticAssembly {
    func statisticCoordinator() -> StatisticCoordinator
    func statisticVC() -> StatisticViewController<StatisticViewImp>
}

extension Assembly: StatisticAssembly {
    func statisticCoordinator() -> StatisticCoordinator {
        StatisticCoordinator(assembly: self, context: .init())
    }

    func statisticVC() -> StatisticViewController<StatisticViewImp> {
        .init(dataProvider: dataProvider)
    }
}

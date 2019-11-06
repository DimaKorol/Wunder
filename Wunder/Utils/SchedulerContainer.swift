//
//  SchedulerContainer.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import RxSwift

protocol SchedulerContainer {
    var scheduler: SchedulerType { get }
}

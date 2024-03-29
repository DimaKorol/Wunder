//
//  StringsService.swift
//  Wunder
//
//  Created by Dima Korolev on 05/11/2019.
//  Copyright © 2019 Dima Korolev. All rights reserved.
//

import Foundation

protocol StringsServiceContainer {
    var strings: (Strings) -> String { get }
}

final class StringsService {
    
    let strings: (Strings) -> String
    
    init() {
        self.strings = Strings.localized
    }
}

// Should be generated by some script (SwiftGen etc.)
enum Strings {
    case mainScreenMapButton
    case mainScreenListButton
    case mainScreenTitle
    case mapScreenTitle
    case mapItemFuel
    case listScreenTitle
    
    fileprivate var key: String {
        switch self {
        case .mainScreenMapButton: return "MainScreen_Map_Button"
        case .mainScreenListButton: return "MainScreen_List_Button"
        case .mainScreenTitle: return "MainScreen_Title"
        case .mapScreenTitle: return "MapScreen_Title"
        case .mapItemFuel: return "MapScreen_Item_Fuel"
        case .listScreenTitle: return "ListScreen_Title"
        }
    }
}

extension Strings {
    
    static func localized( _ string: Strings) -> String {
        return NSLocalizedString(string.key, comment: "")
    }
}

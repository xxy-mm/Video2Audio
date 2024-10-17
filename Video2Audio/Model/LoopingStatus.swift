//
//  LoopingType.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/15.
//

import Foundation

enum LoopingStatus: String {
    case none
    case single
    case list
}

extension LoopingStatus {
    static let all: [Self] = [.none, .single, .list]
}

//
//  VideoConvertStatus.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/15.
//


import Foundation

enum VideoConvertStatus: String, Codable, CaseIterable {
    case processing
    case success
    case error
}

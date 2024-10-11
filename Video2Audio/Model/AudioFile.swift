//
//  AudioFile.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/7.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct AudioFile: FileDocument {
    static var readableContentTypes: [UTType] { [.mpeg4Audio] }
    var url: URL

    init(url: URL) {
        self.url = url
    }

    init(configuration: ReadConfiguration) throws {
        throw NSError() // Not used for exporting
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return try FileWrapper(url: url)
    }
}

//
//  VersionedSchemaTests.swift
//  Video2AudioTests
//
//  Created by xxy-mm on 2024/10/23.
//

import OSLog
import SwiftData
@testable import Video2Audio
import XCTest

final class VersionedSchemaTests: XCTestCase {
    var url: URL!
    var container: ModelContainer!
    var context: ModelContext!

    override func setUpWithError() throws {
        url = FileManager.default.temporaryDirectory.appending(component: "default.store")
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
        try FileManager.default.removeItem(at: url)
        try? FileManager.default.removeItem(at: url.deletingPathExtension().appendingPathExtension("store-shm"))
        try? FileManager.default.removeItem(at: url.deletingPathExtension().appendingPathExtension("store-wal"))
    }

    func testMigrationV1toV2() throws {
        container = try ModelContainer.setupModelContainer(for: VersionedSchemaV1.self , url: self.url)
        context = ModelContext(container)
        try ModelContainer.loadSampleDataSchemaV1(context: context)
        
        let audioItemsV1 = try context.fetch(FetchDescriptor<VersionedSchemaV1.AudioItem>())
        
        XCTAssert(audioItemsV1.count > 0, "should successfully add audio items.")
        
    }
}

//
//  VideoConverter.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/5.
//

import AVFoundation
import Foundation

class VideoConverter {
    static func getAudioURL(from videoURL: URL) -> URL {
        let videoname = videoURL.deletingPathExtension().lastPathComponent
        return getOutputURL(filename: videoname)
    }

    static func convertVideoToAudio(video url: URL, audio outputURL: URL) async -> Bool {
        let videoAsset = AVAsset(url: url)
        do {
            let audioAsset = try await getAudioAsset(video: videoAsset)
            let exportSession = AVAssetExportSession(asset: audioAsset, presetName: AVAssetExportPresetAppleM4A)!
            exportSession.outputFileType = .m4a
            exportSession.outputURL = outputURL
            await exportSession.export()
            return true
        } catch {
            print("Convert failed: \(error.localizedDescription)")
            return false
        }
    }

    static func getAudioAsset(video asset: AVAsset) async throws -> AVAsset {
        let composition = AVMutableComposition()
        let audioTracks = try await asset.loadTracks(withMediaType: .audio)

        for track in audioTracks {
            let timeRange = try await track.load(.timeRange)
            let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            try compositionTrack?.insertTimeRange(timeRange, of: track, at: timeRange.start)
            compositionTrack?.preferredTransform = try await track.load(.preferredTransform)
        }

        return composition
    }

    static func getOutputURL(filename: String) -> URL {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to open user directory")
        }
        return dir.appending(component: filename + "_audio.mp4")
    }
}

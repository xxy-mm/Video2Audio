//
//  MVideoConverter.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/5.
//

import AVFoundation
import Foundation

@Observable
class MVideoConverter {
    var audioResults = [AudioResult]()

    func initAudioResults(video urls: [URL]) {
        guard !urls.isEmpty else {
            print("No urls provided")
            return
        }

        audioResults = urls.map { AudioResult(videoURL: $0, audioURL: getAudioURL(from: $0)) }
    }

    func convert(video urls: [URL]) async {
        for audioResult in audioResults {
            do {
                try await convertVideoToAudio(video: audioResult.videoURL, outputURL: audioResult.audioURL)
                
                DispatchQueue.main.async{
                    audioResult.status = .success
                }
                
            } catch {
                DispatchQueue.main.async{
                    audioResult.status = .error
                }
                
            }
        }
    }

    func getAudioURL(from videoURL: URL) -> URL {
        let videoname = videoURL.deletingPathExtension().lastPathComponent
        return getOutputURL(filename: videoname)
    }

    func convertVideoToAudio(video url: URL, outputURL: URL) async throws {
        let videoAsset = AVAsset(url: url)
        let audioAsset = try await getAudioAsset(video: videoAsset)

        let exportSession = AVAssetExportSession(asset: audioAsset, presetName: AVAssetExportPresetAppleM4A)!
        exportSession.outputFileType = .m4a
        exportSession.outputURL = outputURL
        await exportSession.export()
        print("convertion finished")
    }

    func getAudioAsset(video asset: AVAsset) async throws -> AVAsset {
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

    func getOutputURL(filename: String) -> URL {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to open user directory")
        }
        return dir.appending(component: filename, directoryHint: .notDirectory)
    }
}



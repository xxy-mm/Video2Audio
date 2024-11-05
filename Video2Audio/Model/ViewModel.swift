//
//  ViewModel.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/11/5.
//

import Foundation

@Observable
class ViewModel {
    var audioPlayer = AudioPlayer()
    var playlist: Playlist?
    
    func setPlaylist(_ playlist: Playlist) {
        self.playlist = playlist
        audioPlayer.setAudios(playlist.audios)
        audioPlayer.play()
    }
    
    
}

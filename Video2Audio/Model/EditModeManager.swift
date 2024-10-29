//
//  EditModeManager.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/27.
//

import Foundation

@Observable
final class EditModeManager {
    private(set) var isEditing: Bool
    
    init(isEditing: Bool = false) {
        self.isEditing = isEditing
    }
    
    func toggle() {
        isEditing.toggle()
    }
    
    func edit() {
        isEditing = true
    }
    
    func done() {
        isEditing = false
    }

}

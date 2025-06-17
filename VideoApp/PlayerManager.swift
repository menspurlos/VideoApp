//
//  PlayerManager.swift
//  VideoApp
//
//  Created by Dmitry Grishkin on 11.06.2025.
//

import Combine

class PlayerManager {
    static let shared = PlayerManager()
    let isMuted = CurrentValueSubject<Bool, Never>(false)
    
    func toggleMute() {
        isMuted.send(!isMuted.value)
    }
}

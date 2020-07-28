//
//  SoundManager.swift
//  DCMemory
//
//  Created by Valeryia Beizer on 7/28/20.
//  Copyright © 2020 Valeryia Beizer. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: - Enum
enum SoundEffect {
  case flip
  case shuffle
  case match
  case nomatch
}

class SoundManager {
  // MARK: - Variables
  static var audioPlayer: AVAudioPlayer?
  
  // MARK: - Methods
  static func playSound(_ effect: SoundEffect) {
    var soundFileName = ""
    switch effect {
    case .flip:
      soundFileName = "cardflip"
    case .shuffle:
      soundFileName = "shuffle"
    case .match:
      soundFileName = "dingcorrect"
    case .nomatch:
      soundFileName = "dingwrong"
    }
    
    let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
    guard bundlePath != nil else {
      print("Couldn't find sound file \(soundFileName) in the bundle")
      return
    }
    
    let soundURL = URL(fileURLWithPath: bundlePath!)
    do {
      self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
      self.audioPlayer?.play()
    } catch {
      print("Couldn't create the audio player object for sound file \(soundFileName)")
    }
  }
}

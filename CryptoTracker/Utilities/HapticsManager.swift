//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 07.03.22.
//

import CoreHaptics
import Foundation

enum HapticsManager {
    
    case began,changed,ended
    
    private var engine: CHHapticEngine? {
        let engine: CHHapticEngine
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device does not support CoreHaptics")
            return nil
        }
        
        do {
            engine = try CHHapticEngine()
            try engine.start()
            return engine
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
            return nil
            
        }
    }
    
    func playFeedback() {
        guard let engine = engine else {
            return
        }
        
        var intensity: CHHapticEventParameter
        var sharpness: CHHapticEventParameter
        var relativeTime: TimeInterval = 1
        
        switch self {
        case .began:
            intensity =  CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            relativeTime = 0.5
        case .changed:
            intensity =  CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            relativeTime = 0.5
        case .ended:
            intensity =  CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            relativeTime = 0.5
        }
                
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: relativeTime)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
            print("playing feedback")
        } catch {
            print("Failed to play pattern: \(error).")
        }
    }
}

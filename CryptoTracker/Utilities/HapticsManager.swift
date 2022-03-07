//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Kevin Hoàng on 07.03.22.
//

import CoreHaptics
import Foundation

class HapticsManager {
    
    static let instance = HapticsManager()
    
    private var engine: CHHapticEngine
    
    init?() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device does not support CoreHaptics")
            return nil
        }
        
        do {
            engine = try CHHapticEngine()
            try engine.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
            return nil
        }
        
        engine.stoppedHandler = { reason in
            print("The engine stopped: \(reason)")
        }

        // If something goes wrong, attempt to restart the engine immediately
        engine.resetHandler = { [weak self] in
            print("The engine reset")

            do {
                try self?.engine.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }
    
    func playFeedback(for eventType: HapticEventType) {
        
        var intensity: CHHapticEventParameter
        var sharpness: CHHapticEventParameter
        
        switch eventType {
        case .began:
            intensity =  CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        case .changed:
            intensity =  CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4)
            sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        case .ended:
            intensity =  CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        }
                
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        do {
            try engine.start()
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            print("playing feedback")
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

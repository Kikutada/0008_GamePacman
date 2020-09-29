//
//  BasedComponents.swift
//  0003_GameArchTest
//
//  Created by Kikutada on 2020/08/12.
//  Copyright © 2020 Kikutada. All rights reserved.
//

import Foundation

// Frame time of system at 60fps
let SYSTEM_FRAME_TIME = 16 //ms

/// Based object class
class CbObject {

    /// Kind of Message ID to handled events in object
    enum EnMessage: Int {
        case None
        case Update
        case Timer
        case Touch
        case Swipe
        case Accel
    }
    
    /// When it is true, object can handle events.
    var enabled: Bool = true

    /// For accessing parent objects.
    private var parent: CbObject?
    
    /// Initialize self without parent object
    init() {
        parent = nil
    }
    
    /// Initialize self with parent object
    /// - Parameter object: Parent object.
    init(binding object: CbObject) {
        parent = object
        parent?.bind(self)
    }
    
    /// Bind self to a specified object
    /// - Parameter object: Object to bind self
    func bind( _ object: CbObject) {
        // TO DO: override
        // (This is pure virtual method.)
    }

    /// Send event messages
    /// - Parameters:
    ///   - id: Message ID
    ///   - values: Parameters of message
    func sendEvent(message id: EnMessage, parameter values: [Int]) {
        receiveEvent(sender: self, message: id, parameter: values)
    }
    
    /// Handler called by sendEvent method to receive events
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    func receiveEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        guard enabled else { return }
        if message == .Update {
            update(interval: values[0])
        } else {
            handleEvent(sender: sender, message: message, parameter: values)
        }
    }
    
    /// Event handler
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    func handleEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        // TO DO: override
        // (This is pure virtual method.)
    }

    /// Update handler
    /// - Parameter interval: Interval time(ms) to update
    func update(interval: Int) {
        // TO DO: override
        // (This is pure virtual method.)
    }

}

/// Container class that bind objects
class CbContainer : CbObject {
    
    private var objects: [CbObject] = []

    /// Bind self to a specified object
    /// - Parameter object: Object to bind self.
    override func bind( _ object: CbObject) {
        objects.append(object)
    }
    
    /// Handler called by sendEvent method to receive events
    /// It sends messages to all contained object.
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    override func receiveEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        guard enabled else { return }

        super.receiveEvent(sender: sender, message: message, parameter: values)

        for t in objects {
            t.receiveEvent(sender: self, message: message, parameter: values)
        }
    }
}

/// Countdown timer class
///
///  Usage:
///  - var timer: CbTimer!
///  - timer = CbTimer(binding: self)
///  - timer.set(time: 1600) //ms
///  - timer.start()  // start counting
///    .. counting ..
///  - if timer.isFired() { /* action */ }
///  - timer.restart()
///
class CbTimer : CbObject {

    private var currentTime = 0
    private var settingTime = 0
    private var eventFired = false

    func reset() {
        currentTime = settingTime
        eventFired = false
        self.enabled = false
    }
    
    func set(interval: Int) {
        settingTime = interval
        reset()
    }

    func start() {
        self.enabled = true
    }

    func restart() {
        reset()
        start()
    }

    func pause() {
        self.enabled = false
    }

    func stop() {
        self.enabled = false
        currentTime = 0
    }

    func get() -> Int {
        return currentTime
    }
    
    func isCounting() -> Bool {
        return self.enabled && !eventFired
    }
    
    func isEventFired() -> Bool {
        return eventFired
    }
    
    /// Update handler
    /// - Parameter interval: Interval time(ms) to update
    override func update(interval: Int) {
        guard isCounting() else { return }

        currentTime -= interval
        if currentTime <= 0 {
            currentTime = 0
            eventFired = true
        }
    }

}

/// Game scene class
/// This class handles sequence in game scene.
///
/// Usage:
/// - resetSequence()
/// - startSequence()
///    ... handleSequence()  is called by update() ...
/// - stopSequence()
///
class CbScene : CbContainer {

    private var timer_sequence: CbTimer!
    private var current_sequence: Int = 0
    private var next_sequence: Int = 0
    
    /// Initialize self
    override init() {
        super.init()
        timer_sequence = CbTimer(binding: self)
        resetSequence()
    }

    /// Initialize self
    /// - Parameter object: Parent object
    override init(binding object: CbObject) {
        super.init(binding: object)
        timer_sequence = CbTimer(binding: self)
        resetSequence()
    }
    
    /// Reset sequence settings to start
    func resetSequence() {
        timer_sequence.reset()
        current_sequence = 0
        next_sequence = 0
        self.enabled = false
    }
    
    /// Start sequence of scene
    func startSequence() {
        self.enabled = true
    }

    /// Stop sequence of scene
    func stopSequence() {
        self.enabled = false
    }
    
    /// Implementation of update method in CbContainer
    /// Handle a sequence with a timer every update cylce
    override func update(interval: Int) {
        if timer_sequence.enabled {
            if timer_sequence.isEventFired() {
                timer_sequence.reset()
                current_sequence = next_sequence
            } else {
                return
            }
        }
        self.enabled = handleSequence(sequence: current_sequence)
    }

    /// Handle sequence
    /// To override in a derived class.
    /// - Parameter sequence: Sequence number
    /// - Returns: If true, continue the sequence, if not, end the sequence.
    func handleSequence(sequence: Int) -> Bool {
        // TO DO: override
        // (This is pure virtual method.)
        return false
    }
    
    /// Get current sequence number
    /// - Returns: Sequence number(from 0  to n)
    func getSequence() -> Int {
        return current_sequence
    }

    /// Get next sequence number
    /// - Returns: Sequence number(from 0  to n)
    func getNextSequence() -> Int {
        return next_sequence
    }

    /// Go to next sequence after the specified time
    /// - Parameters:
    ///   - number: Sequence number
    ///   - time: Waiting time
    func goToNextSequence(_ number: Int = -1, after time: Int = 0) {  // ms
        next_sequence =  (number == -1) ? current_sequence+1 : number
        if time > 0 {
            timer_sequence.set(interval: time)
            timer_sequence.start()
        } else {
            timer_sequence.stop()
            current_sequence = next_sequence
        }
    }

}

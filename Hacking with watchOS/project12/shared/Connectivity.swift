//
//  Connectivity.swift
//  project12
//
//  Created by Clinton de Sá Barreto Maciel on 16/08/22.
//

import Foundation
import SwiftUI
import WatchConnectivity
import ClockKit

class Connectivity: NSObject, ObservableObject {
    
    // MARK: Published
    
    @Published var receivedText = ""
    
    // MARK: Init
    
    override init() {
        super.init()
        
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    // MARK: Methods
    
    /// Guaranteed but not immediate
    /// - Parameter userInfo: data being sent
    func transfer(userInfo: [String: Any]) {
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        session.transferUserInfo(userInfo)
    }
    
    /// Instant, but not guaranteed
    /// - Parameter data: data being sent
    func send(message: [String: Any]) {
        let session = WCSession.default
        guard session.isReachable else { return }
        session.sendMessage(message) { response in
            DispatchQueue.main.async {
                self.receivedText = "Received response: \(response)"
            }
        }
    }
    
    /// Will happen, overrides previous calls
    /// - Parameter data: data being sent
    func setContext(to data: [String: Any]) {
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        do {
            try session.updateApplicationContext(data)
        } catch {
            receivedText = "Alert! Updating app context failed"
        }
    }
    
    func sendFile(on url: URL) {
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        session.transferFile(url, metadata: nil)
    }
    
    #if os(iOS)
    func updateComplication(with data: [String: Any]) {
        let session = WCSession.default
        guard session.activationState == .activated, session.isComplicationEnabled else { return }
        session.transferCurrentComplicationUserInfo(data)
        receivedText = "Attempted to send complication data. Remaining transfers: \(session.remainingComplicationUserInfoTransfers)"
    }
    #endif
}

// MARK: WCSessionDelegate

extension Connectivity: WCSessionDelegate {
    #if os(iOS)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard activationState == .activated, session.isWatchAppInstalled else { return }
        DispatchQueue.main.async {
            self.receivedText = "Watch App is installed"
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    #else
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    #endif
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let text = userInfo["text"] as? String {
            DispatchQueue.main.async {
                self.receivedText = text
            }
        } else if let number = userInfo["number"] as? String {
            #if os(watchOS)
            UserDefaults.standard.set(number, forKey: "complication_number")
            let server = CLKComplicationServer.sharedInstance()
            server.activeComplications?.forEach({ complication in
                server.reloadTimeline(for: complication)
            })
            #endif
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let text = message["text"] as? String else { return }
        DispatchQueue.main.async {
            self.receivedText = text
        }
        replyHandler(["response": "Send response"])
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            self.receivedText = "Received context \(applicationContext)"
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let fileManager = FileManager.default
        let fileURL = Helper.getDocumentsDirectory().appendingPathComponent("saved_file", conformingTo: .fileURL)
        
        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
            
            try fileManager.copyItem(at: file.fileURL, to: fileURL)
            let content = try String(contentsOf: fileURL)
            receivedText = "Received file with content:\n\(content)"
        } catch {
            receivedText = "File transfer failed with error: \(error.localizedDescription)"
        }
    }
}

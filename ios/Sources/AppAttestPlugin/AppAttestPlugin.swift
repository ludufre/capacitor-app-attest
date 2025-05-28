import Foundation
import Capacitor
import CryptoKit
import DeviceCheck

@objc(AppAttestPlugin)
public class AppAttestPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AppAttestPlugin"
    public let jsName = "AppAttest"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "isSupported", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "generateKey", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "attestKey", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "generateAssertion", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "storeKeyId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getStoreKeyId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "clearStoreKeyId", returnType: CAPPluginReturnPromise)
    ]
    private let keyIdKey = "AttestKeyId"

    // MARK: - Helper Methods
    
    private func validateService() throws {
        guard DCAppAttestService.shared.isSupported else {
            throw AppAttestError.notSupported
        }
    }
    
    private func validateKeyId(from call: CAPPluginCall) throws -> String {
        guard let keyId = call.getString("keyId") else {
            throw AppAttestError.missingKeyId
        }
        return keyId
    }
    
    private func createClientDataHash(from string: String) throws -> Data {
        guard let data = string.data(using: .utf8) else {
            throw AppAttestError.invalidData
        }
        return Data(SHA256.hash(data: data))
    }
    
    // MARK: - Error Types
    
    private enum AppAttestError: LocalizedError {
        case notSupported
        case missingKeyId
        case missingChallenge
        case missingPayload
        case invalidData
        
        var errorDescription: String? {
            switch self {
            case .notSupported:
                return "App Attest is not supported on this device"
            case .missingKeyId:
                return "keyId is required"
            case .missingChallenge:
                return "challenge is required"
            case .missingPayload:
                return "payload is required"
            case .invalidData:
                return "Invalid data format"
            }
        }
    }

    // MARK: - Plugin Methods

    @objc func isSupported(_ call: CAPPluginCall) {
        let isSupported = DCAppAttestService.shared.isSupported
        call.resolve(["isSupported": isSupported])
    }
    
    @objc func generateKey(_ call: CAPPluginCall) {
        Task {
            do {
                try validateService()
                let keyId = try await DCAppAttestService.shared.generateKey()
                await call.resolve(["keyId": keyId])
            } catch {
                await call.reject("Error generating key: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func attestKey(_ call: CAPPluginCall) {
        guard let challenge = call.getString("challenge") else {
            call.reject(AppAttestError.missingChallenge.localizedDescription)
            return
        }
        
        Task {
            do {
                try validateService()
                let keyId = try validateKeyId(from: call)
                let clientDataHash = try createClientDataHash(from: challenge)
                
                let attestation = try await DCAppAttestService.shared.attestKey(keyId, clientDataHash: clientDataHash)
                
                await call.resolve([
                    "attestation": attestation.base64EncodedString(),
                    "keyId": keyId,
                    "challenge": challenge
                ])
            } catch {
                await call.reject("Error attesting key: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func generateAssertion(_ call: CAPPluginCall) {
        guard let payloadString = call.getString("payload") else {
            call.reject(AppAttestError.missingPayload.localizedDescription)
            return
        }
        
        Task {
            do {
                try validateService()
                let keyId = try validateKeyId(from: call)
                let clientDataHash = try createClientDataHash(from: payloadString)
                
                let assertion = try await DCAppAttestService.shared.generateAssertion(keyId, clientDataHash: clientDataHash)
                
                await call.resolve([
                    "assertion": assertion.base64EncodedString(),
                    "keyId": keyId
                ])
            } catch {
                await call.reject("Error generating assertion: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func storeKeyId(_ call: CAPPluginCall) {
        do {
            let keyId = try validateKeyId(from: call)
            UserDefaults.standard.set(keyId, forKey: keyIdKey)
            call.resolve(["success": true])
        } catch {
            call.reject(error.localizedDescription)
        }
    }
    
    @objc func getStoredKeyId(_ call: CAPPluginCall) {
        let keyId = UserDefaults.standard.string(forKey: keyIdKey)
        call.resolve([
            "keyId": keyId as Any,
            "hasStoredKey": keyId != nil
        ])
    }
    
    @objc func clearStoredKeyId(_ call: CAPPluginCall) {
        UserDefaults.standard.removeObject(forKey: keyIdKey)
        call.resolve(["success": true])
    }
}
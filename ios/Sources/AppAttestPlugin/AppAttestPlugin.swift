import Foundation
import Capacitor
import CryptoKit
import DeviceCheck

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(AppAttestPlugin)
public class AppAttestPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AppAttestPlugin"
    public let jsName = "AppAttest"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "isSupported", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "generateKey", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "attestKey", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "generateAssertion", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "hashPayload", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "storeKeyId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getStoreKeyId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "clearStoreKeyId", returnType: CAPPluginReturnPromise)
    ]
    private let keyIdKey = "AttestKeyId"

    @objc func isSupported(_ call: CAPPluginCall) {
           let isSupported = DCAppAttestService.shared.isSupported
           call.resolve(["isSupported": isSupported])
       }
       
       @objc func generateKey(_ call: CAPPluginCall) {
           Task {
               do {
                   let service = DCAppAttestService.shared
                   
                   guard service.isSupported else {
                       await call.reject("App Attest não é suportado neste dispositivo")
                       return
                   }
                   
                   let keyId = try await service.generateKey()
                   await call.resolve(["keyId": keyId])
                   
               } catch {
                   await call.reject("Erro ao gerar chave: \(error.localizedDescription)")
               }
           }
       }
       
       @objc func attestKey(_ call: CAPPluginCall) {
           guard let keyId = call.getString("keyId") else {
               call.reject("keyId é obrigatório")
               return
           }
           
           guard let challenge = call.getString("challenge") else {
               call.reject("challenge é obrigatório")
               return
           }
           
           Task {
               do {
                   let service = DCAppAttestService.shared
                   
                   guard service.isSupported else {
                       await call.reject("App Attest não é suportado neste dispositivo")
                       return
                   }
                   
                   guard let challengeData = challenge.data(using: .utf8) else {
                       await call.reject("Challenge inválido")
                       return
                   }
                   
                   let clientDataHash = Data(SHA256.hash(data: challengeData))
                   let attestation = try await service.attestKey(keyId, clientDataHash: clientDataHash)
                   
                   await call.resolve([
                       "attestation": attestation.base64EncodedString(),
                       "keyId": keyId,
                       "challenge": challenge
                   ])
                   
               } catch {
                   await call.reject("Erro ao atestar chave: \(error.localizedDescription)")
               }
           }
       }
       
       @objc func generateAssertion(_ call: CAPPluginCall) {
           guard let keyId = call.getString("keyId") else {
               call.reject("keyId é obrigatório")
               return
           }
           
           guard let payloadString = call.getString("payload") else {
               call.reject("payload é obrigatório")
               return
           }
           
           Task {
               do {
                   let service = DCAppAttestService.shared
                   
                   guard service.isSupported else {
                       await call.reject("App Attest não é suportado neste dispositivo")
                       return
                   }
                   
                   guard let payloadData = payloadString.data(using: .utf8) else {
                       await call.reject("Payload inválido")
                       return
                   }
                   
                   let clientDataHash = Data(SHA256.hash(data: payloadData))
                   let assertion = try await service.generateAssertion(keyId, clientDataHash: clientDataHash)
                   
                   await call.resolve([
                       "assertion": assertion.base64EncodedString(),
                       "keyId": keyId
                   ])
                   
               } catch {
                   await call.reject("Erro ao gerar assertion: \(error.localizedDescription)")
               }
           }
       }
       
       @objc func hashPayload(_ call: CAPPluginCall) {
           guard let payload = call.getString("payload") else {
               call.reject("payload é obrigatório")
               return
           }
           
           guard let payloadData = payload.data(using: .utf8) else {
               call.reject("Payload inválido")
               return
           }
           
           let hash = Data(SHA256.hash(data: payloadData))
           call.resolve(["hash": hash.base64EncodedString()])
       }
       
       @objc func storeKeyId(_ call: CAPPluginCall) {
           guard let keyId = call.getString("keyId") else {
               call.reject("keyId é obrigatório")
               return
           }
           
           UserDefaults.standard.set(keyId, forKey: keyIdKey)
           call.resolve(["success": true])
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

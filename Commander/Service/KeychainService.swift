//
//  KeychainService.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 14.12.2025.
//

import Foundation
import Security
#warning("todo: calculate storage for all logged users indeed single user")
enum KeychainKey: String, CaseIterable {
    case balance
    
    var defaultValue: String? {
        switch self {
        case .balance: "650"
        default: nil
        }
    }
}

struct KeychainService {
    static private var appGroupName:String {
        return Keys.appGroup.rawValue
    }
    
    static func saveToken(_ token: String, forKey key: KeychainKey) -> Bool {
        
        guard let data = token.data(using: .utf8) else { return true }
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.key,
            kSecValueData as String: data,
            kSecAttrSynchronizable as String: kCFBooleanTrue ?? true,
            kSecAttrService as String: appGroupName,
            kSecAttrAccessGroup as String: appGroupName,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error Saving Token To Key Chain")
            return false
        } else {
#if DEBUG
            print("Token Saved with status \(status) ", token)
#endif
            return true
        }
    }
        
    static func getToken(forKey key: KeychainKey, optional:Bool = false) -> String? {
        print("getTokengetToken")
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrSynchronizable as String: kCFBooleanTrue ?? true,
            kSecAttrService as String: appGroupName,
            kSecAttrAccessGroup as String: appGroupName
        ] as [String : Any]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        if status == errSecSuccess, let data = tokenData as? Data {
            let new = String(data: data, encoding: .utf8)
            print("getTokengetToken key: \(key), token: \(new) ")
            
            return new
        }
#if DEBUG
        print("Error Retrieving Token from Key Chain ", key)
#if os(iOS)
        print("iOS")
#else
        print("notios")
#endif
#endif
        return key.defaultValue
    }
}

extension KeychainKey {
    var key:String {
        (Bundle.main.bundleIdentifier ?? "") + "." + rawValue
    }
}

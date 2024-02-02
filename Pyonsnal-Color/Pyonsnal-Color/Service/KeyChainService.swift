//
//  KeyChainService.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/03.
//

import Foundation
import Security

final class KeyChainService: NSObject {
    
    static let shared = KeyChainService()
    private override init() {}
    
    func set(value: String, to key: String) -> Bool {
        guard let tokenData = value.data(using: .utf8) else { return false }
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : key,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData : tokenData
        ]
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess { return true }
        else if status == errSecDuplicateItem {
            delete(with: key)
            set(value: value, to: key)
        }
        return false
    }
    
    func get(with key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        }
        return nil
    }
    
    @discardableResult
    func delete(with key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : key,
        ]
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}


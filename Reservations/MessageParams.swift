//
// MessageParams.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct MessageParams: Codable {

    public var phone: String
    public var message: String

    public init(phone: String, message: String) {
        self.phone = phone
        self.message = message
    }
}

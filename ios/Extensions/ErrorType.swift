//
//  ErrorType.swift
//  flutter_smartcar_auth
//
//  Created by Jesus Coronado on 04/11/24.
//
import SmartcarAuth

/// Extension to handle class properties in an easier way
extension AuthorizationError.ErrorType {
    /// Returns the enum converted to **String**
    var stringValue: String  {
        switch self {
        case .accessDenied: return "accessDenied"
        case .invalidSubscription: return "invalidSubscription"
        case .missingAuthCode: return "missingAuthCode"
        case .missingQueryParameters: return "missingQueryParameters"
        case .unknownError: return "unknownError"
        case .userExitedFlow: return "userExitedFlow"
        case .vehicleIncompatible: return "vehicleIncompatible"
        }
    }
}

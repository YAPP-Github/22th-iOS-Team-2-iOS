//
//  Log.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/21.
//

import Foundation
import os.log

enum LogType: String {
    /// 디버깅 관련 정보
    case debug
    /// 도움이 되지만, 필수적이지 않은 정보
    case info
    /// 네트워크 관련 정보
    case network
    /// 에러 정보
    case error
    /// 코드 결함이나 버그 정보
    case fault
    
    var osLogType: OSLogType {
        switch self {
        case .debug:
            return .debug
        case .info:
            return .info
        case .network:
            return .debug
        case .error:
            return .error
        case .fault:
            return .fault
        }
    }
    
    var category: String {
        switch self {
        case .debug:
            return "🛠️ Debug"
        case .info:
            return "ℹ️ Info"
        case .network:
            return "🕸️ Network"
        case .error:
            return "⚠️ Error"
        case .fault:
            return "🚨 Fault"
        }
    }
}

class Log {
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
    
    /// 디버깅 관련 정보
    static func d(
        message: String,
        fileName: String = #file,
        functionName: String = #function
    ) {
        self.log(
            message: message,
            fileName: fileName,
            functionName: functionName,
            logType: .debug
        )
    }
    
    /// 도움이 되지만, 필수적이지 않은 정보
    static func i(
        message: String,
        fileName: String = #file,
        functionName: String = #function
    ) {
        self.log(
            message: message,
            fileName: fileName,
            functionName: functionName,
            logType: .info
        )
    }
    
    /// 네트워크 관련 정보
    static func n(
        message: String,
        fileName: String = #file,
        functionName: String = #function
    ) {
        self.log(
            message: message,
            fileName: fileName,
            functionName: functionName,
            logType: .network
        )
    }
    
    /// 에러 정보
    static func e(
        message: String,
        fileName: String = #file,
        functionName: String = #function
    ) {
        self.log(
            message: message,
            fileName: fileName,
            functionName: functionName,
            logType: .error
        )
    }
    
    /// 코드 결함이나 버그 정보
    static func f(
        message: String,
        fileName: String = #file,
        functionName: String = #function
    ) {
        self.log(
            message: message,
            fileName: fileName,
            functionName: functionName,
            logType: .fault
        )
    }
    
    private static func log(
        message: String,
        fileName: String,
        functionName: String,
        logType: LogType
    ) {
        let logger  = Logger(subsystem: Log.subsystem, category: logType.category)
        
        let fileURL = URL(fileURLWithPath: fileName, isDirectory: false)
        let fileName = fileURL.lastPathComponent
        
        let message = """
        [\(logType.category) - \(fileName)]
        \(functionName)
        \(message)
        """
        
        switch logType {
        case .debug:
            logger.debug("\(message, privacy: .public)")
        case .info:
            logger.info("\(message, privacy: .public)")
        case .network:
            logger.debug("\(message, privacy: .public)")
        case .error:
            logger.error("\(message, privacy: .public)")
        case .fault:
            logger.fault("\(message, privacy: .public)")
        }
        
    }
    
}

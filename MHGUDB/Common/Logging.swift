//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation

/// Add logging implementation to capture logs to your location of choice
var loggers = [Logger]()

protocol Logger {
    func log(_ text: String)
    func log(search: String)
    func log(error: String)
    func log(page: String, event: String?, details: String?, metadata: [String: Any]?)
}

func Log(error: String) {
    for logger in loggers {
        logger.log(error: error)
    }
}

func Log(_ text: String) {
    for logger in loggers {
        logger.log(text)
    }
}

func Log(search: String) {
    for logger in loggers {
        logger.log(search: search)
    }
}

func Log(page: String, event: String? = nil, details: String? = nil, metadata: [String: Any]? = nil) {
    for logger in loggers {
        logger.log(page: page, event: event, details: details, metadata: metadata)
    }
}

class Logs {
    class func start() {
        #if DEBUG
            loggers.append(ConsoleLogger(showErrorsOnly: true))
        #endif
    }
}

class ConsoleLogger: Logger {
    static let dateFormatter = DateFormatter()
    var showErrorsOnly: Bool
    
    init(showErrorsOnly: Bool = true) {
        self.showErrorsOnly = showErrorsOnly
        // TODO: Come up with a better format
        ConsoleLogger.dateFormatter.dateStyle = .short
        ConsoleLogger.dateFormatter.timeStyle = .medium
    }

    private func log(text: String) {
        print("Log [" + ConsoleLogger.dateFormatter.string(from: Date()) + "] " + text)
    }
    
    func log(_ text: String) {
        guard !showErrorsOnly else { return }
        log(text: text)
    }
    
    func log(search: String) {
        guard !showErrorsOnly else { return }
        log(text: "Search: \(search)")
    }
    
    func log(error: String) {
        log(text: "*ERROR* " + error)
    }

    func log(page: String, event: String?, details: String?, metadata: [String: Any]?) {
        guard !showErrorsOnly else { return }
        log(text:  [page, event, details].compactMap{ return $0 }.joined(separator: " - "))
    }
}


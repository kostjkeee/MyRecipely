// LoggerInvoker.swift

import UIKit

/// Инвокер
final class LoggerInvoker {
    // MARK: - Singleton

    static let shared = LoggerInvoker()

    // MARK: - Private properties

    private let logger = Logger()
    private var commands: [LogCommand] = []
    private var timer: Timer?

    // MARK: - Public Methods

    func addLogCommand(_ command: LogCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
        timer = Timer.scheduledTimer(
            timeInterval: 20.0,
            target: self,
            selector: #selector(makeSnapshot),
            userInfo: nil,
            repeats: false
        )
    }

    // MARK: - Private Methods

    private func executeCommandsIfNeeded() {
        commands.forEach { self.logger.writeMessageToLog($0.logMessage) }
        commands = []
    }

    @objc private func makeSnapshot() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let screeenshotData = windowScene?.windows.first?.takeScreenshot().pngData() {
            logger.saveScreenshot(screeenshotData)
        }
        timer?.invalidate()
        timer = nil
    }
}

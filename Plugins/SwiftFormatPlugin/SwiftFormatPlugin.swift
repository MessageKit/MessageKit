// MIT License
//
// Copyright (c) 2017-2022 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import PackagePlugin

// MARK: - SwiftFormatPlugin

@main
struct SwiftFormatPlugin: CommandPlugin {
  func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
    var argumentExtractor = ArgumentExtractor(arguments)
    let files = argumentExtractor.extractOption(named: "file")

    let process = Process()
    process.launchPath = try context.tool(named: "swiftformat").path.string
    process.arguments = [
      files.first!,
      "--swiftversion",
      "5.6",
      "--cache",
      context.pluginWorkDirectory.string + "/swiftformat.cache",
    ]

    try process.run()
    process.waitUntilExit()

    switch process.terminationStatus {
    case EXIT_SUCCESS:
      break
    case EXIT_FAILURE:
      throw CommandError.lintFailure
    default:
      throw CommandError.unknownError(exitCode: process.terminationStatus)
    }
  }
}

// MARK: - CommandError

enum CommandError: Error {
  case lintFailure
  case unknownError(exitCode: Int32)
}

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

// MARK: - SwiftLintCommandPlugin

@main
struct SwiftLintCommandPlugin: CommandPlugin {
  func performCommand(context: PackagePlugin.PluginContext, arguments _: [String]) async throws {
    let swiftLintTool = try context.tool(named: "swiftlint")
    let swiftLintPath = URL(fileURLWithPath: swiftLintTool.path.string)

    let swiftLintArgs = [
      "lint",
      "--path", context.package.directory.string,
      "--config", context.package.directory.string + "/.swiftlint.yml",
      "--strict",
    ]

    let task = try Process.run(swiftLintPath, arguments: swiftLintArgs)
    task.waitUntilExit()

    if task.terminationStatus == 0 || task.terminationStatus == 2 {
      // no-op
    } else {
      throw CommandError.unknownError(exitCode: task.terminationStatus)
    }
  }
}

// MARK: - CommandError

enum CommandError: Error {
  case unknownError(exitCode: Int32)
}

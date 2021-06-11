//
//  FileStorage.swift
//  DataPersistence
//
//  Created by Mikhail Rubanov on 25.09.2020.
//

import Foundation

final class FileStorage<M> where M: Codable {
    init() {
        createDocumentsFolder()
    }

    // MARK: - Private methods

    private func writeToFile(_ item: M) {
        let data = try? JSONEncoder().encode(item)
        fileManager.createFile(atPath: path, contents: data, attributes: nil)
    }

    private func createDocumentsFolder() {
        try? fileManager.createDirectory(at: pathService.fileRepositoryFolderPath,
                                         withIntermediateDirectories: true, attributes: nil)
    }

    internal var path: String {
        pathService.path
    }

    private let pathService = PathService<M>()
    private let fileManager = FileManager.default
}

extension FileStorage: StorageProtocol {
    func read() -> M? {
        if let data = fileManager.contents(atPath: path),
           let object = try? JSONDecoder().decode(M.self, from: data) {
            return object
        }

        return nil
    }

    func save(_ model: M) {
        writeToFile(model)
    }

    func clear() {
        try? fileManager.removeItem(atPath: path)
    }
}

extension FileStorage {
    final class PathService<T> {
        #if SHOULD_USE_DEBUG
        private lazy var folderName: String = "FileRepository" + (Config.launchArguments.folderSuffix ?? "")
        #else
        private let folderName = "FileRepository"
        #endif

        private let fileManager: FileManager = .default

        var path: String {
            fileRepositoryFolderPath
                .appendingPathComponent(fileName).path
        }

        var fileRepositoryFolderPath: URL {
            return fileManager.documentsDirectory()
                .appendingPathComponent(folderName, isDirectory: true)
        }

        private var fileName: String {
            return String(describing: T.self)
        }
    }
}

extension FileManager {
    public func documentsDirectory() -> URL {
        urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

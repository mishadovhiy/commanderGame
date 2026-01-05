//
//  IcloudService.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 04.01.2026.
//

import Foundation

struct IcloudService {
    var url: URL? {
        FileManager.default.url(
            forUbiquityContainerIdentifier: nil
        )?.appendingPathComponent("Documents")
    }
    
    enum DataType: String {
        case uncompletedProgress
        case completedProgress
    }
    
    func writeData(_ data: Data, type: DataType) {
        guard let dir = url else {
            print("iCloud not available")
            return
        }
        
        let url = dir.appendingPathComponent(type.rawValue)
        
        do {
            try FileManager.default.createDirectory(
                at: dir,
                withIntermediateDirectories: true
            )
            
            try data.write(to: url, options: .atomic)
        } catch {
            print(error, " ", #function, #file, #line)
            return
        }
    }
    
    func load(type: DataType) -> Data? {
        guard let dir = url else {
            print("iCloud not available")
            return nil
        }

        let url = dir.appendingPathComponent(type.rawValue)
        do {
            let data = try Data(contentsOf: url)
            return data
        }
        catch {
            print(error, " ", #function, #file, #line)
            return nil
        }
    }
}

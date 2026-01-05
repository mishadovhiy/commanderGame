//
//  IcloudService.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 04.01.2026.
//

import Foundation

struct IcloudService {
    private var icloudURL: URL? {
        FileManager.default.url(
            forUbiquityContainerIdentifier: nil
        )?.appendingPathComponent("Documents")
    }
    
    private var localURL: URL? {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
    }
    
    func writeData(_ data: Codable, type: DataType, local: Bool = true) {
        guard let dir = local ? self.localURL : icloudURL else {
            print("iCloud not available")
            return
        }
        print("wrignfsdsa ")
        let url = dir.appendingPathComponent(type.rawValue)
        
        do {
            try FileManager.default.createDirectory(
                at: dir,
                withIntermediateDirectories: true
            )
            let dataModel = try data.encode()
            try dataModel?.write(to: url, options: .atomic)
            if local {
                self.writeData(data, type: type, local: false)
            }
        } catch {
            print(error, " ", #function, #file, #line)
            return
        }
    }
    
    func launchLocalDB(completion: @escaping()->()) {
        DispatchQueue(label: "db", qos: .background).async {
            let data = load(type: .dataBase, isLocal: false) as? IcloudService.DataType.Responses.Cloud
            if let data {
                writeData(data, type: .dataBase)
            } else {
                writeData(IcloudService.DataType.Responses.Cloud.init(), type: .dataBase)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func load(type: DataType, isLocal: Bool = true) -> Codable? {
        guard let dir = isLocal ? self.localURL : icloudURL else {
            print("iCloud not available")
            return nil
        }

        let url = dir.appendingPathComponent(type.rawValue)
        do {
            let data = try Data(contentsOf: url)
//            let response = try JSONDecoder().decode(type.responseType.self, from: data)
            return try type.responseType.init(data)
        }
        catch {
            print(error, " ", #function, #file, #line)
            return nil
        }
    }
    
    enum DataType: String {
        case dataBase

        var responseType: Codable.Type {
            switch self {
            case .dataBase:
                CloudDataBaseModel.self
            }
        }
        
        struct Responses {
            typealias Cloud = CloudDataBaseModel
        }
    }
    
    var loadCloudDataBase: DataType.Responses.Cloud? {
        return load(type: .dataBase) as? DataType.Responses.Cloud
    }
    
    var loadDataBaseCopy: DataType.Responses.Cloud {
        get {
            load(type: .dataBase, isLocal: true) as? DataType.Responses.Cloud ?? .init()
        }
        set {
            writeData(newValue, type: .dataBase, local: true)
        }
    }
}

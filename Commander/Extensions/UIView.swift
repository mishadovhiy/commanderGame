//
//  UIView.swift
//  Commander
//
//  Created by Mykhailo Dovhyi on 13.12.2025.
//

import UIKit

extension UIView {
    func positionInSuperview(_ position: CGPoint = .zero, s: UIView) -> CGPoint {
        var position = position
        position.x += frame.minX
        position.y += frame.minY
        print(position, " positionpositionposition")
        if self.superview == s {
            return position
        } else {
            return self.superview?.positionInSuperview(position, s: s) ?? position
        }
    }
}

extension Decodable {
    init(_ data: Data?) throws {
        guard let data else {
            throw NSError(domain: "no data", code: -10)
        }
        do {
            let decoder = PropertyListDecoder()
            let decodedData = try decoder.decode(Self.self, from: data)
            self = decodedData
        } catch {
            do {
                let decoder = JSONDecoder()
                self = try decoder.decode(Self.self, from: data)
            } catch {
                throw error
            }
        }
    }
}

extension Encodable {
    func encode() throws -> Data? {

        do {
            return try JSONEncoder().encode(self)
        }
        catch {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            return try encoder.encode(self)
        }
    }
    
    func dictionary() throws -> [String:Any?]? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?]
            return json
        } catch {
            throw error
        }
    }
}

extension String {
    var addingSpacesBeforeLargeLetters: Self {
        self.replacingOccurrences(
                    of: "([a-z])([A-Z])",
                    with: "$1 $2",
                    options: .regularExpression
                )
    }
}

extension UITableViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = .init()
    }
}

extension UICollectionViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = .init()
    }
}

extension UIViewController {
    static func initiateDefault() -> Self {
        UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(
                withIdentifier: .init(
                    describing: Self.self
                )
            ) as! Self
    }
}

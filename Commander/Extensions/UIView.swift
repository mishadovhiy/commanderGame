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
        if self.superview == s {
            return position
        } else {
            return self.superview?.positionInSuperview(position, s: s) ?? position
        }
    }
    
    @IBInspectable var hasDarkOverlay: Bool {
        get {
            layer.name?.contains("DarkOverlay") ?? false
        }
        set {
            print("egrfseads")
            if !newValue {
                return
            }
            if layer.name?.contains("DarkOverlay") ?? false {
                return
            }
            layer.name = "\(layer.name ?? "")DarkOverlay"
            print("rtegrfseda")
            addDarkOverlay()
        }
    }
    
    func addDarkOverlay() {
        addSubview(DestinationOutMaskedView())
    }
    
    func addBlurView() {
        (0..<3).forEach { _ in
            addBlurItemView()
        }
    }
    
    private func addBlurItemView() {
        let style: UIBlurEffect.Style = .init(rawValue: -1000)!
        let effect = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: effect)
        let vibracity = UIVisualEffectView(effect: effect)
        view.contentView.addSubview(vibracity)
        addSubview(view)

        [view, vibracity].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor),
                $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor),
                $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor)
            ])
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
    
    nonisolated
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
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(
                withIdentifier: .init(
                    describing: Self.self
                )
            ) as! Self
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

extension UIColor {
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            self.init(red: 255, green: 0, blue: 0, alpha: 1)
            return
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
        
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

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
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            .init(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
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
    
    @IBInspectable var cornerRaious: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var hasContainer: Bool {
        get {
            layer.name?.contains("hasContainer") ?? false
        }
        set {
            print("egrfseads")
            if !newValue {
                return
            }
            if layer.name?.contains("hasContainer") ?? false {
                return
            }
            layer.name = "\(layer.name ?? "")hasContainer"
            addSubview(ContainerMaskedView(isHorizontal: nil))
        }
    }
    
    func addDarkOverlay() {
        let view = DestinationOutMaskedView()
        view.layer.zPosition = 999
        addSubview(view)
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
        insertSubview(view, at: 0)

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
    
    var numbers: Int? {
        Int(self.filter({$0.isNumber}))
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
    static func initiateDefault(_ storyboardName: String = "Main") -> Self {
        let vc = UIStoryboard(name: storyboardName, bundle: nil)
            .instantiateViewController(
                withIdentifier: .init(
                    describing: Self.self
                )
            ) as! Self
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    func present(vc: UIViewController,
                 completion: @escaping()->() = {}) {
        if let presentedVC = self.presentedViewController {
            presentedVC.present(vc: vc, completion: completion)
        } else {
            self.present(vc, animated: true, completion: completion)
        }
    }
}

extension UIApplication {
    var activeWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let windowScene = self.connectedScenes
                .first(where: {
                    $0.activationState == .foregroundActive
                }) as? UIWindowScene {
                
                if let keyWindow = windowScene.windows.first(where: {
                    $0.isKeyWindow
                }) {
                    return keyWindow
                }
            }
        }
        return UIApplication.shared.keyWindow
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
    
    var isLight: Bool {
        let (r, g, b) = self.rgbInSRGB()
        let brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness >= 0.5
    }

    private func rgbInSRGB() -> (CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) { return (r, g, b) }

        guard let srgb = cgColor.converted(
            to: CGColorSpace(name: CGColorSpace.sRGB)!,
            intent: .relativeColorimetric,
            options: nil),
              let comps = srgb.components
        else { return (0, 0, 0) }

        if comps.count == 2 {
            return (comps[0], comps[0], comps[0])
        } else {
            return (comps[0], comps[1], comps[2])
        }
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

extension UILabel {
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = superview else {
            return
        }
        
        self.font = font.customFont()
    }
}

extension UIFont {
    func customFont() -> Self {
        return .init(name: "Tiny5-Regular", size: self.pointSize)!
    }
}

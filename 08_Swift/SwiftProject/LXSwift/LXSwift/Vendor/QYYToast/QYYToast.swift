//
//  QYYToast.swift
//
//  Created by Romilson Nunes on 21/10/16.
//
//

//import QYYIconFont_Base
import UIKit

@objc public enum QYYToastType: Int {
    case `default`
    case success
    case error
    case warning
    case info
    case onGoing
}

public enum ToastLayout {
    // MARK: Public

    public static let duration: TimeInterval = 5.0 // second(s)

    // MARK: Internal

    static let space: CGFloat = 8
    static let font = UIFont.systemFont(ofSize: 15)

    static var height: CGFloat {
        let defaultHeight: CGFloat = 44.0
        if #available(iOS 11.0, *) {
            if let top = UIApplication.shared.delegate?.window??.safeAreaInsets.top {
                return defaultHeight + top
            }
        }
        return defaultHeight
    }

    static var width: CGFloat { return UIScreen.main.bounds.size.width }

    static var contentTop: CGFloat {
        if #available(iOS 11.0, *) {
            if let top = UIApplication.shared.delegate?.window??.safeAreaInsets.top {
                return top
            }
        }
        return 20
    }

    static var leftMargin: CGFloat {
        let defaultHeight: CGFloat = 8.0
        if #available(iOS 11.0, *) {
            if let left = UIApplication.shared.delegate?.window??.safeAreaInsets.left {
                return defaultHeight + left
            }
        }
        return defaultHeight
    }
}

open class QYYToast: UIView {
    // MARK: Lifecycle

    // MARK: - Initialization

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: ToastLayout.width, height: ToastLayout.height))

        startNotificationObservers()
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Open

    @objc open var duration: TimeInterval = ToastLayout.duration

    @objc open fileprivate(set) var isAnimating = false
    @objc open fileprivate(set) var isDragging = false

    @objc open var font = ToastLayout.font {
        didSet {
            titleLabel.font = font
        }
    }

    @objc open var textColor = UIColor.black {
        didSet {
            titleLabel.textColor = textColor
        }
    }

    // MARK: - Override Toolbar

    @objc override open func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
    }

    // MARK: Public

    // MARK: - Properties

    public static var sharedToast = QYYToast()

    // MARK: Fileprivate

    fileprivate var tapAction: (() -> ())?
    /// Views
    fileprivate lazy var titleLabel: UILabel = { [unowned self] in
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = self.font
        titleLabel.textColor = self.textColor
        return titleLabel
    }()

    fileprivate var dismissTimer: Timer? {
        didSet {
            if oldValue?.isValid == true {
                oldValue?.invalidate()
            }
        }
    }

    // MARK: - Helper

    fileprivate static func iconString(type: QYYToastType) -> NSAttributedString? {
        return nil
//        switch type {
//        case .default:
//            return NSAttributedString(string: "")
//        case .success:
//            return QYYFontImage.attributedStringIcon(name: "toast-success", fontSize: 17, color: UIColor(red: 102/255, green: 193/255, blue: 49/255, alpha: 1))
//        case .error:
//            return QYYFontImage.attributedStringIcon(name: "toast-error", fontSize: 17, color: UIColor(red: 252/255, green: 92/255, blue: 92/255, alpha: 1))
//        case .warning:
//            return QYYFontImage.attributedStringIcon(name: "toast-warn", fontSize: 17, color: UIColor.orange)
//        case .info:
//            return QYYFontImage.attributedStringIcon(name: "toast-base", fontSize: 17, color: UIColor(red: 70/255, green: 128/255, blue: 255/255, alpha: 1))
//        case .onGoing:
//            return QYYFontImage.attributedStringIcon(name: "toast-down", fontSize: 17, color: UIColor(red: 70/255, green: 128/255, blue: 255/255, alpha: 1))
//        }
    }

    // MARK: - Observers

    fileprivate func startNotificationObservers() {
        /// Enable orientation tracking
        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }

        /// Add Orientation notification
        NotificationCenter.default.addObserver(self, selector: #selector(QYYToast.orientationStatusDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    // MARK: - Orientation Observer

    @objc fileprivate func orientationStatusDidChange(_ notification: Foundation.Notification) {
        setupUI()
    }

    // MARK: - Setups

    // TODO: - Use autolayout
    fileprivate func setupFrames() {
        let y: CGFloat = ToastLayout.contentTop
        let x: CGFloat = ToastLayout.leftMargin
        let size = self.titleLabel.sizeThatFits(CGSize(width: ToastLayout.width - 2 * x, height: CGFloat.greatestFiniteMagnitude))
        self.titleLabel.frame.size = size
        self.frame = CGRect(x: 0, y: 0, width: ToastLayout.width, height: y + ToastLayout.space + size.height + ToastLayout.space)
        self.titleLabel.center = CGPoint(x: ToastLayout.width * 0.5, y: y + ToastLayout.space + size.height * 0.5)
    }

    fileprivate func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.QYCColor(lightColor: .white, darkColor: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1))

        self.layer.zPosition = CGFloat.greatestFiniteMagnitude - 1
        self.isMultipleTouchEnabled = false
        self.isExclusiveTouch = true

        self.frame = CGRect(x: 0, y: 0, width: ToastLayout.width, height: ToastLayout.height)
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleLeftMargin]

        // Add subviews
        self.addSubview(self.titleLabel)

        // Gestures
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.addGestureRecognizer(pan)
    }

    // MARK: - Actions

    @objc fileprivate func scheduledDismiss() {
        self.hide(completion: nil)
    }

    // MARK: - Tap gestures

    @objc fileprivate func didTap(_ gesture: UIGestureRecognizer) {
        self.isUserInteractionEnabled = false
        self.tapAction?()
        self.hide(completion: nil)
    }

    @objc fileprivate func didPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended:
            self.isDragging = false
            if frame.origin.y < 0 || self.duration <= 0 {
                self.hide(completion: nil)
            }

        case .began:
            self.isDragging = true

        case .changed:
            guard let superview = self.superview else {
                return
            }

            guard let gestureView = gesture.view else {
                return
            }

            let translation = gesture.translation(in: superview)
            // Figure out where the user is trying to drag the view.
            let newCenter = CGPoint(x: superview.bounds.size.width/2,
                                    y: gestureView.center.y + translation.y)

            // See if the new position is in bounds.
            if newCenter.y >= (-1 * ToastLayout.height/2), newCenter.y <= ToastLayout.height/2 {
                gestureView.center = newCenter
                gesture.setTranslation(CGPoint.zero, in: superview)
            }

        default:
            break
        }
    }

    // MARK: Private

    private var previousStatusBarStyle: UIStatusBarStyle?
}

public extension QYYToast {
    // MARK: - Public Methods

    func show(withImage image: UIImage?, message: String?, type: QYYToastType = .default, duration: TimeInterval = ToastLayout.duration, onTap: (() -> ())?) {
        guard let window = UIApplication.shared.windows.first else { return }
        /// Invalidate dismissTimer
        self.dismissTimer = nil
        self.tapAction = onTap
        self.duration = duration
        /// Content
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        let mess = NSMutableAttributedString(string: message ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.QYCColor(lightColor: textColor, darkColor: .white)])
        if let iconImage = image {
            mess.insert(NSAttributedString(string: "   "), at: 0)
            let attchment = NSTextAttachment()
            attchment.image = iconImage
            attchment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
            mess.insert(NSAttributedString(attachment: attchment), at: 0)
        } else {
            mess.insert(NSAttributedString(string: "  "), at: 0)
            if let msg = QYYToast.iconString(type: type) {
                mess.insert(msg, at: 0)
            }
        }

        self.titleLabel.attributedText = mess

        /// Prepare frame
        var frame = self.frame
        frame.origin.y = -frame.size.height
        self.frame = frame

        self.setupFrames()

        self.isUserInteractionEnabled = true
        self.isAnimating = true

        /// Add to window
        if #available(iOS 11.0, *), let top =
            UIApplication.shared.delegate?.window??.safeAreaInsets.top, top > 0
        {
            // iPhone X
            self.previousStatusBarStyle = UIApplication.shared.statusBarStyle
            window.rootViewController?.setStatusBarStyle(style: .default)
        } else {}
        window.addSubview(self)

        /// Show animation
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            var frame = self.frame
            frame.origin.y += frame.size.height
            self.frame = frame
        }) { _ in
            self.isAnimating = false
        }

        // Schedule to hide
        if self.duration > 0 {
            let time = self.duration + 0.3
            self.dismissTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(QYYToast.scheduledDismiss), userInfo: nil, repeats: false)
        }
    }

    func hide(completion: (() -> ())?) {
        guard !self.isDragging else {
            self.dismissTimer = nil
            return
        }

        if self.superview == nil {
            isAnimating = false
            return
        }

        // Case are in animation of the hide
        if isAnimating {
            return
        }
        isAnimating = true

        // Invalidate timer auto close
        self.dismissTimer = nil

        /// Show animation
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            var frame = self.frame
            frame.origin.y -= frame.size.height
            self.frame = frame

        }) { _ in
            self.removeFromSuperview()
//            UIApplication.shared.delegate?.window??.windowLevel = UIWindow.Level.normal

            if #available(iOS 11.0, *), let style = self.previousStatusBarStyle {
                UIApplication.shared.setStatusBarStyle(style, animated: true)
            }
            self.isAnimating = false
            completion?()
        }
    }

    // MARK: - Public Motheds

    @objc static func hide(completion: (() -> ())? = nil) {
        self.sharedToast.hide(completion: completion)
    }

    @objc static func showToast(withMessage: String?, type: QYYToastType) {
        show(withMessage: withMessage, type: type, image: nil, onTap: nil)
    }

    @objc static func showToast(withMessage: String?, type: QYYToastType, duration: TimeInterval) {
        show(withMessage: withMessage, type: type, duration: duration, image: nil, onTap: nil)
    }

    @objc static func show(withMessage message: String?, type: QYYToastType, duration: TimeInterval = ToastLayout.duration, image: UIImage?, onTap: (() -> ())? = nil) {
        self.sharedToast.show(withImage: image, message: message, type: type, duration: duration, onTap: onTap)
    }
}

extension UIViewController {
    // Note: Make sure "View controller-based status bar appearance" is set to NO in your target settings or this won't work
    func setStatusBarStyle(style: UIStatusBarStyle) {
        UIApplication.shared.statusBarStyle = style
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension UIColor {
    static func QYCColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { train in
                guard train.userInterfaceStyle != .light else {
                    return lightColor
                }
                return darkColor
            }
        } else {
            return lightColor
        }
    }
}

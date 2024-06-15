// UIView+Extension.swift

import UIKit

/// Добавление шимера
extension UIView {
    /// Старт анимации шимера
    /// - Parameters:
    ///   - animationSpeed: скорость анимации
    func startShimmeringAnimation(animationSpeed: TimeInterval = 2.5) {
        layoutIfNeeded()
        backgroundColor = .systemGray4
        layer.mask?.removeFromSuperlayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.lightGray.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: bounds.width * 2,
            height: bounds.height * 2
        )
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat(Float.pi / 2), 0, 0, 1)
        layer.mask = gradientLayer

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = animationSpeed
        animation.fromValue = -2 * bounds.width
        animation.toValue = 2 * bounds.width
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }

    /// Остановка анимации шимера
    func stopShimmeringAnimation() {
        backgroundColor = .clear
        layer.mask = nil
    }
}

extension UIView {
    /// Создание скриншота
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

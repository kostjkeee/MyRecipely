// DetailsSkeletonCell.swift

import UIKit

/// Ячейка с шиммером для деталей
final class DetailsSkeletonCell: UITableViewCell {
    // MARK: - Puplic Properties

    static let identifier = "DetailsSkeletonCell"

    // MARK: - Private Properties

    private let gradientLayer = CAGradientLayer()

    private let recipeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
        return imageView
    }()

    private let enercView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return view
    }()

    private let carbohydratesView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return view
    }()

    private let fatsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return view
    }()

    private let proteinsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return view
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        recipeImage.startShimmeringAnimation()
        enercView.startShimmeringAnimation()
        carbohydratesView.startShimmeringAnimation()
        fatsView.startShimmeringAnimation()
        proteinsView.startShimmeringAnimation()
        addGradient()
    }

    // MARK: - Public Methods

    private func addGradient() {
        gradientLayer.frame = CGRect(
            x: 0,
            y: 390,
            width: contentView.bounds.width,
            height: contentView.bounds.height - 10
        )
        let path = UIBezierPath(
            roundedRect: contentView.bounds,
            byRoundingCorners: [.topRight, .topLeft],
            cornerRadii: CGSize(width: 24, height: 24)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        gradientLayer.mask = maskLayer
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.clipsToBounds = true
        contentView.addSubview(recipeImage)
        contentView.addSubview(enercView)
        contentView.addSubview(carbohydratesView)
        contentView.addSubview(fatsView)
        contentView.addSubview(proteinsView)
        gradientLayer.colors = [
            UIColor(named: ColorPalette.loginGradient.rawValue)?.cgColor ?? "",
            UIColor.white.cgColor
        ]
        contentView.layer.addSublayer(gradientLayer)
    }

    private func setConstraints() {
        makeRecipeImageConstraints()
        makeEnercViewConstraints()
        makeBackViewConcntraints(view: carbohydratesView, equalTo: enercView)
        makeBackViewConcntraints(view: fatsView, equalTo: carbohydratesView)
        makeBackViewConcntraints(view: proteinsView, equalTo: fatsView)
    }

    private func makeRecipeImageConstraints() {
        recipeImage.translatesAutoresizingMaskIntoConstraints = false
        recipeImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recipeImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        recipeImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        recipeImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }

    private func makeEnercViewConstraints() {
        enercView.translatesAutoresizingMaskIntoConstraints = false
        enercView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -125).isActive = true
        enercView.topAnchor.constraint(equalTo: recipeImage.bottomAnchor, constant: 20).isActive = true
        enercView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIScreen.main.bounds.height / 2)
            .isActive = true
        enercView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        enercView.heightAnchor.constraint(equalToConstant: 53).isActive = true
    }

    private func makeBackViewConcntraints(view: UIView, equalTo: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: equalTo.trailingAnchor, constant: 5).isActive = true
        view.topAnchor.constraint(equalTo: recipeImage.bottomAnchor, constant: 20).isActive = true
        view.heightAnchor.constraint(equalToConstant: 53).isActive = true
        view.widthAnchor.constraint(equalToConstant: 78).isActive = true
    }
}

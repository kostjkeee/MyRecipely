// RecipesCollectionViewCell.swift

import UIKit

/// Ячейка каталога рецептов
final class RecipesCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    static let identifier = "RecipesCollectionViewCell"

    // MARK: - Visual Components

    private let recipesImageView: UIImageView = {
        let button = UIImageView()
        button.clipsToBounds = true
        button.layer.cornerRadius = 18
        return button
    }()

    private let darkTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorPalette.darkTitleView.rawValue)
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    // MARK: - Private Properties

    private var isShimming = true
    private var isFirstInit = true
    private var textBackgroundHeight: CGFloat = 0

    // MARK: - Public Properties

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 2 : 0
            titleLabel
                .backgroundColor = isSelected ? UIColor(named: ColorPalette.tappedButtonAlpha.rawValue) :
                UIColor(named: ColorPalette.darkTitleView.rawValue)
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupVeiew()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        setupVeiew()
        setConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isShimming {
            recipesImageView.startShimmeringAnimation()
        }
        titleLabel.isHidden = isShimming
    }

    // MARK: - Public Methods

    func setInfo(info: DishCategory?) {
        if let info = info {
            isShimming = false
            recipesImageView.stopShimmeringAnimation()
            recipesImageView.image = UIImage(named: info.imageName)
            titleLabel.text = info.type.rawValue
            if contentView.frame.width < 150 {
                titleLabel.font = .verdana(ofSize: 16)
            } else {
                titleLabel.font = .verdana(ofSize: 20)
            }
        } else {
            isShimming = true
        }
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.layer.cornerRadius = 18
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor(named: ColorPalette.tappedButtonBounds.rawValue)?.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 2, height: 5)
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 0.5
    }

    private func setupVeiew() {
        contentView.addSubview(recipesImageView)
        recipesImageView.addSubview(darkTitleView)
        darkTitleView.addSubview(titleLabel)
    }

    private func setConstraints() {
        if isFirstInit {
            textBackgroundHeight = contentView.frame.size.height / 5
            isFirstInit = false
        }
        makeRecipesButtonConstraints()
        makeDarkTitleViewConstraints()
        makeDarkTitleLabelConstraints()
    }

    private func makeRecipesButtonConstraints() {
        recipesImageView.translatesAutoresizingMaskIntoConstraints = false
        recipesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        recipesImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        recipesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        recipesImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }

    private func makeDarkTitleViewConstraints() {
        darkTitleView.translatesAutoresizingMaskIntoConstraints = false
        darkTitleView.leadingAnchor.constraint(equalTo: recipesImageView.leadingAnchor).isActive = true
        darkTitleView.trailingAnchor.constraint(equalTo: recipesImageView.trailingAnchor).isActive = true
        darkTitleView.bottomAnchor.constraint(equalTo: recipesImageView.bottomAnchor).isActive = true
        darkTitleView.heightAnchor.constraint(equalToConstant: textBackgroundHeight).isActive = true
    }

    private func makeDarkTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: darkTitleView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: darkTitleView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: darkTitleView.bottomAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: darkTitleView.topAnchor).isActive = true
    }
}

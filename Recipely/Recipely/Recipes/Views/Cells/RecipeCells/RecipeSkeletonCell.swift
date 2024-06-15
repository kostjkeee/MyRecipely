// RecipeSkeletonCell.swift

import UIKit

/// Ячейка с шиммером для рецепта
final class RecipeSkeletonCell: UITableViewCell {
    // MARK: - Constants

    static let identifier = "RecipeSkeletonCell"

    // MARK: - Visual Components

    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorPalette.backgroundTeal.rawValue)
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor(named: ColorPalette.selectedTitle.rawValue)?.cgColor
        return view
    }()

    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let recipeLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 12)
        return label
    }()

    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 12)
        return label
    }()

    // MARK: - Public Properties

    override var isSelected: Bool {
        didSet {
            background.layer.borderWidth = isSelected ? 2 : 0
        }
    }

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createView()
        setConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        startShimming()
    }

    // MARK: - Private Methods

    private func startShimming() {
        recipeImageView.startShimmeringAnimation()
        recipeLabel.startShimmeringAnimation()
        timerLabel.startShimmeringAnimation()
        caloriesLabel.startShimmeringAnimation()
        recipeImageView.image = nil
        recipeLabel.text = nil
        timerLabel.text = nil
        caloriesLabel.text = nil
    }

    private func createView() {
        selectionStyle = .none
        contentView.addSubview(background)
        background.addSubview(recipeImageView)
        background.addSubview(recipeLabel)
        background.addSubview(timerLabel)
        background.addSubview(caloriesLabel)
    }

    private func setConstraints() {
        setBackgroundViewConstraints()
        setRecipeImageViewConstraints()
        setRecipeLabelConstraints()
        setTimerLabelConstraints()
        setCaloriesLabelConstraints()
    }

    private func setBackgroundViewConstraints() {
        background.translatesAutoresizingMaskIntoConstraints = false
        background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
        background.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    private func setRecipeImageViewConstraints() {
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10).isActive = true
        recipeImageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10).isActive = true
        recipeImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        recipeImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }

    private func setRecipeLabelConstraints() {
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        recipeLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 20).isActive = true
        recipeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -43).isActive = true
        recipeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    private func setTimerLabelConstraints() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 8).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 40).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: 55).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    private func setCaloriesLabelConstraints() {
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesLabel.topAnchor.constraint(equalTo: timerLabel.topAnchor).isActive = true
        caloriesLabel.leadingAnchor.constraint(equalTo: timerLabel.trailingAnchor, constant: 30).isActive = true
        caloriesLabel.widthAnchor.constraint(equalToConstant: 72).isActive = true
        caloriesLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}

// RecipeCell.swift

import UIKit

/// Ячейка с рецептом
final class RecipeCell: UITableViewCell {
    // MARK: - Constants

    static let identifier = "RecipeCell"

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

    private let timerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageName.timer.rawValue)
        return imageView
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 12)
        return label
    }()

    private let pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageName.pizza.rawValue)
        return imageView
    }()

    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 12)
        return label
    }()

    private let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageName.detailsIcon.rawValue)
        return imageView
    }()

    // MARK: - Public Properties

    override var isSelected: Bool {
        didSet {
            background.layer.borderWidth = isSelected ? 2 : 0
        }
    }

    var cellID: IndexPath?

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImageView.image = nil
    }

    // MARK: - Public Methods

    func loadInfo(recipe: RecipeCard?) {
        if let recipe = recipe {
            recipeLabel.text = recipe.label
            timerLabel.text = "\(recipe.totalTime) min"
            caloriesLabel.text = "\(recipe.calories) kkal"
        }
    }

    func setImage(imageData: Data) {
        recipeImageView.image = UIImage(data: imageData)
    }

    // MARK: - Private Methods

    private func createView() {
        selectionStyle = .none
        contentView.addSubview(background)
        background.addSubview(recipeImageView)
        background.addSubview(recipeLabel)
        background.addSubview(timerImageView)
        background.addSubview(timerLabel)
        background.addSubview(pizzaImageView)
        background.addSubview(caloriesLabel)
        background.addSubview(detailImageView)
    }

    private func setConstraints() {
        setBackgroundViewConstraints()
        setRecipeImageViewConstraints()
        setRecipeLabelConstraints()
        setTimerImageViewConstraints()
        setTimerLabelConstraints()
        setPizzaImageViewConstraints()
        setCaloriesLabelConstraints()
        setDetailImageViewConstraints()
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

    private func setTimerImageViewConstraints() {
        timerImageView.translatesAutoresizingMaskIntoConstraints = false
        timerImageView.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 8).isActive = true
        timerImageView.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 20).isActive = true
        timerImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        timerImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    private func setTimerLabelConstraints() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.topAnchor.constraint(equalTo: timerImageView.topAnchor).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: timerImageView.trailingAnchor, constant: 4).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: 55).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    private func setPizzaImageViewConstraints() {
        pizzaImageView.translatesAutoresizingMaskIntoConstraints = false
        pizzaImageView.topAnchor.constraint(equalTo: timerImageView.topAnchor).isActive = true
        pizzaImageView.leadingAnchor.constraint(equalTo: timerLabel.trailingAnchor, constant: 10).isActive = true
        pizzaImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        pizzaImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    private func setCaloriesLabelConstraints() {
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesLabel.topAnchor.constraint(equalTo: timerImageView.topAnchor).isActive = true
        caloriesLabel.leadingAnchor.constraint(equalTo: pizzaImageView.trailingAnchor, constant: 4).isActive = true
        caloriesLabel.widthAnchor.constraint(equalToConstant: 72).isActive = true
        caloriesLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    private func setDetailImageViewConstraints() {
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        detailImageView.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        detailImageView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -2).isActive = true
        detailImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        detailImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

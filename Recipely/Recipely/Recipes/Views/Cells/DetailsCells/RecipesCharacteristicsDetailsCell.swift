// RecipesCharacteristicsDetailsCell.swift

import UIKit

/// Ячейка с характеристиками блюда
final class RecipesCharacteristicsDetailsCell: UITableViewCell {
    // MARK: - Puplic Properties

    static let identifier = "RecipesCharacteristicsDetailsCell"

    // MARK: - Private Properties

    private let enercView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: ColorPalette.characteristics.rawValue)?.cgColor
        view.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return view
    }()

    private let carbohydratesView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: ColorPalette.characteristics.rawValue)?.cgColor
        view.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return view
    }()

    private let fatsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: ColorPalette.characteristics.rawValue)?.cgColor
        view.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return view
    }()

    private let proteinsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: ColorPalette.characteristics.rawValue)?.cgColor
        view.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return view
    }()

    private let enercSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let carbohydratesSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let fatsSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let proteinsSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let enercViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .verdana(ofSize: 10)
        label.textColor = .white
        label.text = Local.RecipesCharacteristicsDetailsCell.enercKcal
        return label
    }()

    private let enercSubViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .verdana(ofSize: 10)
        label.textColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return label
    }()

    private let carbohydratesViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .verdana(ofSize: 10)
        label.textColor = .white
        label.text = Local.RecipesCharacteristicsDetailsCell.carbohydrates
        return label
    }()

    private let carbohydratesSubViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .verdana(ofSize: 10)
        label.textColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return label
    }()

    private let fatsViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .verdana(ofSize: 10)
        label.textColor = .white
        label.text = Local.RecipesCharacteristicsDetailsCell.fats
        return label
    }()

    private let fatsSubViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .verdana(ofSize: 10)
        label.textColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return label
    }()

    private let proteinsViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .verdana(ofSize: 10)
        label.textColor = .white
        label.text = Local.RecipesCharacteristicsDetailsCell.proteins
        return label
    }()

    private let proteinsSubViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .verdana(ofSize: 10)
        label.textColor = UIColor(named: ColorPalette.characteristics.rawValue)
        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setConstraints()
    }

    // MARK: - Public Methods

    func getCharacteristics(recipe: RecipeDetails?) {
        if let recipe = recipe {
            enercView.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
            carbohydratesView.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
            fatsView.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
            proteinsView.backgroundColor = UIColor(named: ColorPalette.characteristics.rawValue)
            enercSubViewLabel.text = "\(recipe.calories) kkal"
            carbohydratesSubViewLabel.text = recipe.carbohydrates
            fatsSubViewLabel.text = recipe.fats
            proteinsSubViewLabel.text = recipe.proteins
        }
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.clipsToBounds = true
        contentView.addSubview(enercView)
        enercView.addSubview(enercSubView)
        contentView.addSubview(carbohydratesView)
        carbohydratesView.addSubview(carbohydratesSubView)
        contentView.addSubview(fatsView)
        fatsView.addSubview(fatsSubView)
        contentView.addSubview(proteinsView)
        proteinsView.addSubview(proteinsSubView)
        enercView.addSubview(enercViewLabel)
        enercSubView.addSubview(enercSubViewLabel)
        carbohydratesView.addSubview(carbohydratesViewLabel)
        carbohydratesSubView.addSubview(carbohydratesSubViewLabel)
        fatsView.addSubview(fatsViewLabel)
        fatsSubView.addSubview(fatsSubViewLabel)
        proteinsView.addSubview(proteinsViewLabel)
        proteinsSubView.addSubview(proteinsSubViewLabel)
    }

    private func setConstraints() {
        makeEnercViewConstraints()
        makeBackViewConcntraints(view: carbohydratesView, equalTo: enercView)
        makeBackViewConcntraints(view: fatsView, equalTo: carbohydratesView)
        makeBackViewConcntraints(view: proteinsView, equalTo: fatsView)
        makeSubViewConcntraints(view: enercSubView, equalTo: enercView)
        makeSubViewConcntraints(view: carbohydratesSubView, equalTo: carbohydratesView)
        makeSubViewConcntraints(view: fatsSubView, equalTo: fatsView)
        makeSubViewConcntraints(view: proteinsSubView, equalTo: proteinsView)
        makeViewLabelConcntraints(label: enercViewLabel, equalTo: enercView)
        makeViewLabelConcntraints(label: carbohydratesViewLabel, equalTo: carbohydratesView)
        makeViewLabelConcntraints(label: fatsViewLabel, equalTo: fatsView)
        makeViewLabelConcntraints(label: proteinsViewLabel, equalTo: proteinsView)
        makeSubViewLabelConcntraints(label: enercSubViewLabel, equalTo: enercSubView)
        makeSubViewLabelConcntraints(label: carbohydratesSubViewLabel, equalTo: carbohydratesSubView)
        makeSubViewLabelConcntraints(label: fatsSubViewLabel, equalTo: fatsSubView)
        makeSubViewLabelConcntraints(label: proteinsSubViewLabel, equalTo: proteinsSubView)
    }

    private func makeEnercViewConstraints() {
        enercView.translatesAutoresizingMaskIntoConstraints = false
        enercView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -125).isActive = true
        enercView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        enercView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        enercView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        enercView.heightAnchor.constraint(equalToConstant: 53).isActive = true
    }

    private func makeBackViewConcntraints(view: UIView, equalTo: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: equalTo.trailingAnchor, constant: 5).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: 78).isActive = true
    }

    private func makeSubViewConcntraints(view: UIView, equalTo: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: equalTo.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: equalTo.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: equalTo.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    private func makeViewLabelConcntraints(label: UILabel, equalTo: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: equalTo.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: equalTo.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: equalTo.topAnchor, constant: 8).isActive = true
        label.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }

    private func makeSubViewLabelConcntraints(label: UILabel, equalTo: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: equalTo.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: equalTo.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: equalTo.bottomAnchor, constant: -4).isActive = true
        label.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}

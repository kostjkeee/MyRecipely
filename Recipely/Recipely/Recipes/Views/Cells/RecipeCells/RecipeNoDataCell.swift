// RecipeNoDataCell.swift

import UIKit

/// Ячейка для отсутствия данных
final class RecipeNoDataCell: UITableViewCell {
    // MARK: - Constants

    static let identifier = "RecipeNoDataCell"

    // MARK: - Visual Components

    private let backgroundSearchGlassView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorPalette.deviderLight.rawValue)
        view.layer.cornerRadius = 12
        return view
    }()

    private let nothingFoundTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .verdanaBold(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.text = Local.RecipeNoDataCell.nothingFoundTitleText
        return label
    }()

    private let nothingFoundLabel: UILabel = {
        let label = UILabel()
        label.font = .verdana(ofSize: 14)
        label.textColor = UIColor(named: ColorPalette.lightInfoText.rawValue)
        label.textAlignment = .center
        label.text = Local.RecipeNoDataCell.nothingFoundText
        return label
    }()

    private let nothingFoundView = UIView()
    private let searchGlassImageView = UIImageView(image: UIImage(named: ImageName.searchGlass.rawValue))

    // MARK: - Public Properties

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

    // MARK: - Private Methods

    private func createView() {
        selectionStyle = .none
        contentView.addSubview(nothingFoundView)
        nothingFoundView.isHidden = false
        nothingFoundView.addSubview(backgroundSearchGlassView)
        backgroundSearchGlassView.addSubview(searchGlassImageView)
        nothingFoundView.addSubview(nothingFoundTitleLabel)
        nothingFoundView.addSubview(nothingFoundLabel)
    }

    private func setConstraints() {
        createNothingFoundViewConstraints()
        createBackgroundNothingFoundViewConstraints()
        createSearchGlassImageViewConstraints()
        createNothingFoundTitleLabelConstraints()
        createNothingFoundLabelConstraints()
    }

    private func createNothingFoundViewConstraints() {
        nothingFoundView.translatesAutoresizingMaskIntoConstraints = false
        nothingFoundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        nothingFoundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -250).isActive = true
        nothingFoundView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        nothingFoundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
    }

    private func createBackgroundNothingFoundViewConstraints() {
        backgroundSearchGlassView.translatesAutoresizingMaskIntoConstraints = false
        backgroundSearchGlassView.topAnchor.constraint(equalTo: nothingFoundView.centerYAnchor)
            .isActive = true
        backgroundSearchGlassView.centerXAnchor.constraint(equalTo: nothingFoundView.centerXAnchor).isActive = true
        backgroundSearchGlassView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backgroundSearchGlassView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func createSearchGlassImageViewConstraints() {
        searchGlassImageView.translatesAutoresizingMaskIntoConstraints = false
        searchGlassImageView.centerYAnchor.constraint(equalTo: backgroundSearchGlassView.centerYAnchor).isActive = true
        searchGlassImageView.centerXAnchor.constraint(equalTo: backgroundSearchGlassView.centerXAnchor).isActive = true
        searchGlassImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        searchGlassImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }

    private func createNothingFoundTitleLabelConstraints() {
        nothingFoundTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingFoundTitleLabel.topAnchor.constraint(equalTo: backgroundSearchGlassView.bottomAnchor, constant: 17)
            .isActive = true
        nothingFoundTitleLabel.centerXAnchor.constraint(equalTo: nothingFoundView.centerXAnchor).isActive = true
        nothingFoundTitleLabel.widthAnchor.constraint(equalTo: nothingFoundView.widthAnchor).isActive = true
        nothingFoundTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

    private func createNothingFoundLabelConstraints() {
        nothingFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingFoundLabel.topAnchor.constraint(equalTo: nothingFoundTitleLabel.bottomAnchor, constant: 25)
            .isActive = true
        nothingFoundLabel.centerXAnchor.constraint(equalTo: nothingFoundView.centerXAnchor).isActive = true
        nothingFoundLabel.widthAnchor.constraint(equalTo: nothingFoundView.widthAnchor).isActive = true
        nothingFoundLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
}

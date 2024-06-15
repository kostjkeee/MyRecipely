// FavoritesViewController.swift

import UIKit

/// Протокол экрана избранного
protocol FavoritesViewProtocol: AnyObject {
    ///  Презентер экрана
    var presenter: FavoritesViewPresenterProtocol? { get set }
    /// Скрытие коллекции
    func hideCollectionView(_ isHiden: Bool)
    /// Обновление данных таблицы
    func reloadTableView()
}

/// Экран избарнного
final class FavoritesViewController: UIViewController {
    // MARK: - Visual Components

    private let favoritesLabel: UILabel = {
        let label = UILabel()
        label.text = Local.FavoritesViewController.viewTitleText
        label.font = .verdanaBold(ofSize: 28)
        return label
    }()

    private let emptyFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = Local.FavoritesViewController.emptyFavoritesText
        label.textAlignment = .center
        label.font = .verdanaBold(ofSize: 18)
        return label
    }()

    private let emptyIconBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorPalette.deviderLight.rawValue)
        view.layer.cornerRadius = 12
        return view
    }()

    private let emptyIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageName.saveIcon.rawValue)
        return imageView
    }()

    private let emptyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Local.FavoritesViewController.emptyDescriptionText
        label.font = .verdana(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: ColorPalette.lightInfoText.rawValue)
        return label
    }()

    private let tableView = UITableView()

    // MARK: - Public Properties

    var presenter: FavoritesViewPresenterProtocol?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTableView()
        createConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        addLogs()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deselectedSelectedRow()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: favoritesLabel)
        view.backgroundColor = .white
        view.addSubview(emptyIconBackgroundView)
        emptyIconBackgroundView.addSubview(emptyIconImageView)
        view.addSubview(emptyFavoritesLabel)
        view.addSubview(emptyDescriptionLabel)
        view.addSubview(tableView)
    }

    private func configureTableView() {
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
        tableView.accessibilityIdentifier = Local.FavoritesTableView.accessibilityIdentifier
    }

    private func createConstraints() {
        createTableViewConstraints()
        createEmptyFavoritesLabelConstraints()
        createEmptyDescriptionLabelConstraints()
        createEmptyIconBackgroundViewConstraints()
        createEmptyIconImageViewConstraints()
    }

    private func deselectedSelectedRow() {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: selectedIndex)?.isSelected = false
        }
    }

    private func createTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func createEmptyFavoritesLabelConstraints() {
        emptyFavoritesLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyFavoritesLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        emptyFavoritesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .isActive = true
        emptyFavoritesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            .isActive = true
    }

    private func createEmptyDescriptionLabelConstraints() {
        emptyDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyDescriptionLabel.topAnchor.constraint(equalTo: emptyFavoritesLabel.bottomAnchor, constant: 12)
            .isActive = true
        emptyDescriptionLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        emptyDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            .isActive = true
        emptyDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            .isActive = true
    }

    private func createEmptyIconBackgroundViewConstraints() {
        emptyIconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        emptyIconBackgroundView.bottomAnchor.constraint(equalTo: emptyFavoritesLabel.topAnchor, constant: -12)
            .isActive = true
        emptyIconBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyIconBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emptyIconBackgroundView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func createEmptyIconImageViewConstraints() {
        emptyIconImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyIconImageView.topAnchor.constraint(equalTo: emptyIconBackgroundView.topAnchor, constant: 13)
            .isActive = true
        emptyIconImageView.leadingAnchor.constraint(equalTo: emptyIconBackgroundView.leadingAnchor, constant: 13)
            .isActive = true
        emptyIconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        emptyIconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }

    private func addLogs() {
        presenter?.sendLog()
    }
}

// MARK: - FavoritesViewController + FavoritesViewProtocol

extension FavoritesViewController: FavoritesViewProtocol {
    func hideCollectionView(_ isHiden: Bool) {
        tableView.isHidden = isHiden
        emptyIconBackgroundView.isHidden = !isHiden
        emptyIconImageView.isHidden = !isHiden
        emptyFavoritesLabel.isHidden = !isHiden
        emptyDescriptionLabel.isHidden = !isHiden
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - FavoritesViewController + UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        switch presenter?.getRecipeInfo() {
        case let .data(recipes):
            hideCollectionView(false)
            tableView.isScrollEnabled = true
            tableView.allowsSelection = true
            return recipes.count
        case .noData:
            hideCollectionView(true)
            return 0
        default:
            hideCollectionView(false)
            tableView.isScrollEnabled = false
            tableView.allowsSelection = false
            return 8
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecipeCell.identifier,
            for: indexPath
        ) as? RecipeCell else { return UITableViewCell() }
        switch presenter?.getRecipeInfo() {
        case let .data(recipes):
            cell.loadInfo(recipe: recipes[indexPath.row])
            guard let imageData = recipes[indexPath.row].imageData else { return cell }
            cell.setImage(imageData: imageData)
        default:
            cell.loadInfo(recipe: nil)
        }
        return cell
    }
}

// MARK: - RecepeCategoryView + UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.goToRecipeDetail(numberOfRecipe: indexPath.row)
        tableView.cellForRow(at: indexPath)?.isSelected = true
    }

    func tableView(
        _ tableView: UITableView,
        commit _: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        presenter?.removeRecipe(indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

// RecipesPresenter.swift

import Foundation

/// Протокол презентера экрана рецептов
protocol RecipesViewPresenterProtocol: AnyObject {
    /// Инициализатор с присвоением вью
    init(view: RecipesViewProtocol, coordinator: RecipesCoordinator, loggerService: LoggerServiceProtocol?)
    /// Функция получения информации о ячейке
    func getInfo() -> ViewState<[DishCategory]>
    /// Получение информации о количестве категорий
    func getCategoryCount() -> ViewState<[DishCategory]>
    /// Переход на экран категории
    func goToCategory(_ categoryNumber: Int)
    /// Добавление логов
    func sendLog()
}

/// Презентер экрана м
final class RecipesPresenter: RecipesViewPresenterProtocol {
    // MARK: - Private Properties

    private let informationSource = InformationSource()
    private weak var coordinator: RecipesCoordinator?
    private weak var view: RecipesViewProtocol?
    private var loggerService: LoggerServiceProtocol?
    private var isFirstRequest = true
    private var state: ViewState<[DishCategory]>

    // MARK: - Initializers

    required init(
        view: RecipesViewProtocol,
        coordinator: RecipesCoordinator,
        loggerService: LoggerServiceProtocol?
    ) {
        self.view = view
        self.coordinator = coordinator
        self.loggerService = loggerService
        state = .noData()
    }

    // MARK: - Public Methods

    func goToCategory(_ categoryNumber: Int) {
        coordinator?.goToCategory(informationSource.categories[categoryNumber].type)
    }

    func getInfo() -> ViewState<[DishCategory]> {
        state
    }

    func getCategoryCount() -> ViewState<[DishCategory]> {
        if isFirstRequest {
            isFirstRequest = false
            state = .data(informationSource.categories)
        }
        return state
    }

    func sendLog() {
        loggerService?.log(.openRecipe)
    }

    // MARK: - Private Methods

    @objc private func setInfo() {
        isFirstRequest = false
        state = .data(informationSource.categories)
        view?.reloadCollectionView()
    }
}

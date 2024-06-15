// RecepeCategoryPresenter.swift

import Foundation

/// Протокол презентера экрана категории рецептов
protocol RecepeCategoryPresenterProtocol: AnyObject {
    /// Инициализатор с присвоением вью
    init(
        view: RecepeCategoryViewProtocol,
        coordinator: RecipesCoordinator,
        networkService: NetworkServiceProtocol?,
        category: RecipeCategories,
        loggerService: LoggerServiceProtocol?
    )
    /// Экшн кнопки назад
    func back()
    /// Изменение состояние сортировки рецептов
    func selectedSort(_ sortType: SortTypes, newSortState: SortState)
    /// Переход на экран деталей
    func goToRecipeDetail(numberOfRecipe: Int)
    /// Поиск рецептов по запросу
    func searchRecipes(withText text: String)
    /// Добавление логов
    func sendLog()
    /// Загрузить картинку для ячейки
    func loadImageDataForCell(_ imageURL: String, complitionHandler: @escaping (Data) -> Void)
    /// Получить данные
    func getRecipesFromNetwork(search: String?, complition: VoidHandler?)
    /// Состояние загрузки данных
    var state: ViewState<[RecipeCard]> { get set }
}

/// Презентер экрана категории рецептов
final class RecepeCategoryPresenter: RecepeCategoryPresenterProtocol {
    // MARK: - Constants

    enum Constants {
        static let whiteSortDirectionRevers = "whiteSortDirectionRevers"
        static let whiteSortDirection = "whiteSortDirection"
        static let blackSortDirection = "sortDirection"
    }

    // MARK: - Private Properties

    private weak var coordinator: RecipesCoordinator?
    private weak var view: RecepeCategoryViewProtocol?
    private var loggerService: LoggerServiceProtocol?
    private var selectedSortMap: [SortTypes: SortState] = [.calories: .withoutSort, .time: .withoutSort] {
        didSet {
            sourceOfRecepies.setNeededInformation(selectedSortMap: selectedSortMap, isSerching: isSearching)
            state = .data(sourceOfRecepies.recipesToShow)
        }
    }

    private var networkService: NetworkServiceProtocol?
    private var sourceOfRecepies = SourceOfRecepies()
    private var category: RecipeCategories
    private var isSearching = false
    var state: ViewState<[RecipeCard]> = .loading {
        didSet {
            view?.updateState()
        }
    }

    // MARK: - Initializers

    required init(
        view: RecepeCategoryViewProtocol,
        coordinator: RecipesCoordinator,
        networkService: NetworkServiceProtocol?,
        category: RecipeCategories,
        loggerService: LoggerServiceProtocol?
    ) {
        self.view = view
        self.coordinator = coordinator
        self.networkService = networkService
        self.category = category
    }

    // MARK: - Public Methods

    func back() {
        coordinator?.backToCategiries()
    }

    func selectedSort(_ sortType: SortTypes, newSortState: SortState) {
        selectedSortMap.updateValue(newSortState, forKey: sortType)
    }

    func goToRecipeDetail(numberOfRecipe: Int) {
        let recipe = sourceOfRecepies.recipesToShow[numberOfRecipe]
        coordinator?.openRecipeDetails(recipeURI: recipe.uri)
    }

    func searchRecipes(withText text: String) {
        guard !text.isEmpty else {
            isSearching = false
            sourceOfRecepies.setNeededInformation(selectedSortMap: selectedSortMap, isSerching: isSearching)
            state = sourceOfRecepies.recipesToShow.isEmpty ? .noData() : .data(sourceOfRecepies.recipesToShow)
            return
        }
        isSearching = true
        getRecipesFromNetwork(search: text)
    }

    func sendLog() {
        loggerService?.log(.openCatagoryOfRecipe)
    }

    func loadImageDataForCell(_ imageURL: String, complitionHandler: @escaping (Data) -> Void) {
        networkService?.getImageData(stringURL: imageURL) { result in
            if case let .success(data) = result {
                complitionHandler(data)
            }
        }
    }

    func getRecipesFromNetwork(search: String?, complition comlition: VoidHandler? = nil) {
        state = .loading
        networkService?.getRecipes(category: category, search: search) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(recipeCard) where recipeCard.isEmpty:
                    self.state = .noData()
                case let .success(recipeCard):
                    self.sourceOfRecepies.setRecipes(
                        recipes: recipeCard,
                        selectedSortMap: self.selectedSortMap,
                        isSerching: self.isSearching
                    )
                    self.state = .data(self.sourceOfRecepies.recipesToShow)
                case let .failure(error):
                    self.state = .error(error) {}
                }
                comlition?()
            }
        }
    }
}

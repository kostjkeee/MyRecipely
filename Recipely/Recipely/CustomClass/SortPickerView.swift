// SortPickerView.swift

import UIKit

/// Протокол датасорса пикера сортировки
protocol SortPickerViewDataSource: AnyObject {
    /// Количество кнопок пикера
    func sortPickerCount(_ sortPicker: SortPickerView) -> Int
    /// Тайтлы для кнопок пикера
    func sortPickerTitle(_ sortPicker: SortPickerView, indexPath: IndexPath) -> String
    /// Действие для нажатого состояния кнопки
    func sortPickerAction(indexPath: IndexPath, newSortState: SortState)
}

/// Пикер сортировки
final class SortPickerView: UIControl {
    // MARK: - Constants

    enum Constants {
        static let whiteSortDirectionRevers = "whiteSortDirectionRevers"
        static let whiteSortDirection = "whiteSortDirection"
        static let blackSortDirection = "sortDirection"
    }

    // MARK: - Public Properties

    weak var dataSource: SortPickerViewDataSource? {
        didSet {
            setupView()
        }
    }

    // MARK: - Private Properties

    private var buttons: [UIButton] = []
    private var selectedSortMap: [UIButton: SortState] = [:]
    private var stackView: UIStackView!

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

    // MARK: - Private Methods

    func setupView() {
        let count = dataSource?.sortPickerCount(self)
        for item in 0 ..< (count ?? 1) {
            let indexPath = IndexPath(row: item, section: 0)
            let title = dataSource?.sortPickerTitle(self, indexPath: indexPath)
            let button = UIButton()
            button.setTitle("\(title ?? "") ", for: .normal)
            button.tag = item
            button.layer.cornerRadius = 18
            button.titleLabel?.font = .verdana(ofSize: 14)
            button.contentVerticalAlignment = .center
            button.backgroundColor = UIColor(named: ColorPalette.backgroundTeal.rawValue)
            button.semanticContentAttribute = .forceRightToLeft
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: ImageName.sortDirection.rawValue), for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.setImage(UIImage(named: ImageName.whiteSortDirection.rawValue), for: .selected)
            button.addTarget(self, action: #selector(selectedButton(sender:)), for: .touchUpInside)
            buttons.append(button)
            selectedSortMap[button] = .withoutSort
            addSubview(button)
        }
        stackView = UIStackView(arrangedSubviews: buttons)
        addSubview(stackView)
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
    }

    private func setState(_ button: UIButton) -> (String, Bool) {
        let isSelected = true
        switch selectedSortMap[button] {
        case .withoutSort:
            selectedSortMap.updateValue(.fromLeastToMost, forKey: button)
            return (Constants.whiteSortDirection, isSelected)
        case .fromLeastToMost:
            selectedSortMap.updateValue(.fromMostToLeast, forKey: button)
            return (Constants.whiteSortDirectionRevers, isSelected)
        case .fromMostToLeast:
            selectedSortMap.updateValue(.withoutSort, forKey: button)
            return (Constants.blackSortDirection, !isSelected)
        default:
            return ("", !isSelected)
        }
    }

    @objc private func selectedButton(sender: UIButton) {
        let selectedButton = buttons[sender.tag]
        let (newImageName, isSelected) = setState(selectedButton)
        selectedButton.setImage(UIImage(named: newImageName), for: .selected)
        selectedButton.isSelected = isSelected
        selectedButton
            .backgroundColor = isSelected ? UIColor(named: ColorPalette.selectedTitle.rawValue) :
            UIColor(named: ColorPalette.backgroundTeal.rawValue)
        dataSource?.sortPickerAction(
            indexPath: IndexPath(item: sender.tag, section: 0),
            newSortState: selectedSortMap[selectedButton] ?? .withoutSort
        )
    }
}

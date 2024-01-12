import UIKit
import ContactsUI
import Contacts

class ContactViewController: UIViewController {
    fileprivate enum ConstantValues {
        static let borderWidth: CGFloat = 0.3
        static let bottomSheetBoxHeigth: CGFloat = 2
        static let searchBarHorithontalEdges: CGFloat = 7
        static let cornerRadius: CGFloat = 10
        static let offset: CGFloat = 12
        static let titleFont: CGFloat = 16
        static let closeButtonCornerRadius: CGFloat = 17
        static let bottomSheetBoxWidth: CGFloat = 24
        static let closeButtonSize: CGFloat = 32
        static let mainTitle = "Добавить контролера"
        static let search = "Search"
        static let addText = "Add"
        static let deleteText = "Delete"
        static let okText = "Ok"
    }
    
    private var viewModel = ContactViewModel()
//    private var sortedArray = [ContactModel]()
//    private var isSearched = false
    
    private let bottomSheetTopLine = UIView().apply {
        $0.backgroundColor = .lightGray
        $0.layer.borderWidth = .init(ConstantValues.borderWidth)
    }
    
    private let viewForTitle = UIView()
    
    private let mainTitle = UILabel().apply {
        $0.text = ConstantValues.mainTitle
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: ConstantValues.titleFont)
        $0.textColor = .white
    }
    
     let closeButton = UIButton().apply {
        $0.setImage(UIImage(named: "x"), for: .normal)
        $0.backgroundColor = .closeButtonBackground
         $0.layer.cornerRadius = ConstantValues.closeButtonCornerRadius
        $0.addTarget(self, action: #selector(closeButtonFunc), for: .touchUpInside)
    }
    
    private let stackViewTitle = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let searchBar = UISearchBar().apply {
        $0.placeholder = ConstantValues.search
        $0.layer.cornerRadius = ConstantValues.cornerRadius
        $0.backgroundColor = .clear
        $0.searchBarStyle = .minimal
        $0.tintColor = .white
    }
    
    private let contactTableView = UITableView().apply {
        $0.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.idetifier)
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground
        setupViews()
        setupConstraints()
        viewModel.customizeSearchBar(searchButton: searchBar)
        searchBar.delegate = self
        contactTableView.dataSource = self
        //contact date
        viewModel.fetchAllContacts()
    }
    
    func alertMessage(title: String, indexPath: Int) {
        var mess = ""
        if viewModel.isSearched {
            mess = "You \(title) \(viewModel.sortedArray[indexPath].name) contact"
        }else {
            mess = "You \(title) \(viewModel.contactsFromPhone[indexPath].name) contact"
        }
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ConstantValues.okText, style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func closeButtonFunc() {
        self.dismiss(animated: true)
    }
}

// MARK: - tableView dataSource
extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isSearched {
            return viewModel.sortedArray.count
        }else {
            return viewModel.contactsFromPhone.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.idetifier, for: indexPath) as! ContactTableViewCell
        if viewModel.isSearched {
            cell.configure(model: viewModel.sortedArray[indexPath.row])
        }else {
            cell.configure(model: viewModel.contactsFromPhone[indexPath.row])
        }
        cell.selectionStyle = .none
        cell.clickButton = { [weak self] typeOfContact in
            print(typeOfContact)
            if typeOfContact == .add {
                self?.alertMessage(title: ConstantValues.addText, indexPath: indexPath.row)
            }else {
                self?.alertMessage(title: ConstantValues.deleteText, indexPath: indexPath.row)
            }
        }
        return cell
    }
}

// MARK: - searchBar delegate
extension ContactViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchByUsername(searchText: searchText)
        contactTableView.reloadData()
        print(viewModel.isSearched)
    }
}

// MARK: - setupViews, setupConstaints
private extension ContactViewController {
    func setupViews(){
        [bottomSheetTopLine, stackViewTitle, searchBar, contactTableView].forEach {
            view.addSubview($0)
        }
        viewForTitle.addSubview(mainTitle)
        [viewForTitle, closeButton].forEach { i in
            stackViewTitle.addArrangedSubview(i)
        }
    }
    
    func setupConstraints() {
        bottomSheetTopLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(ConstantValues.offset)
            make.width.equalTo(ConstantValues.bottomSheetBoxWidth)
            make.height.equalTo(ConstantValues.bottomSheetBoxHeigth)
        }
        stackViewTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bottomSheetTopLine.snp.bottom).offset(ConstantValues.offset)
            make.leading.equalToSuperview().offset(ConstantValues.titleFont)
            make.trailing.equalToSuperview().inset(ConstantValues.titleFont)
        }
        mainTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(ConstantValues.closeButtonSize)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(stackViewTitle.snp.bottom).offset(ConstantValues.titleFont)
            make.leading.equalToSuperview().offset(ConstantValues.searchBarHorithontalEdges)
            make.trailing.equalToSuperview().inset(ConstantValues.searchBarHorithontalEdges)
        }
        contactTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(ConstantValues.cornerRadius)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

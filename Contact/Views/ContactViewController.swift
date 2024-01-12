import UIKit
import ContactsUI
import Contacts

class ContactViewController: UIViewController {
    private var viewModel = ContactViewModel()
//    private var sortedArray = [ContactModel]()
//    private var isSearched = false
    
    private let bottomSheetTopLine = UIView().apply {
        $0.backgroundColor = .lightGray
        $0.layer.borderWidth = .init(0.3)
    }
    
    private let viewForTitle = UIView()
    
    private let mainTitle = UILabel().apply {
        $0.text = "Добавить контролера"
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .white
    }
    
     let closeButton = UIButton().apply {
        $0.setImage(UIImage(named: "x"), for: .normal)
        $0.backgroundColor = .closeButtonBackground
        $0.layer.cornerRadius = 17
        $0.addTarget(self, action: #selector(closeButtonFunc), for: .touchUpInside)
    }
    
    private let stackViewTitle = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let searchBar = UISearchBar().apply {
        $0.placeholder = "Search"
        $0.layer.cornerRadius = 10
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
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
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
                self?.alertMessage(title: "Add", indexPath: indexPath.row)
            }else {
                self?.alertMessage(title: "Remove", indexPath: indexPath.row)
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.width.equalTo(24)
            make.height.equalTo(2)
        }
        stackViewTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bottomSheetTopLine.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        mainTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(stackViewTitle.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().inset(7)
        }
        contactTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

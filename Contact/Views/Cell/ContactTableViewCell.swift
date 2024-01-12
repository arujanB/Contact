import UIKit

class ContactTableViewCell: UITableViewCell {
    fileprivate enum ConstantValues {
        static let addButtonBorderWidth: CGFloat = 1
        static let stacViewSpacing: CGFloat = 2
        static let edgesInset: CGFloat = 6
        static let cornerRadius: CGFloat = 10
        static let phoneNumberSize: CGFloat = 12
        static let nameSize: CGFloat = 14
        static let stackViewLeading: CGFloat = 16
        static let imageIcon: CGFloat = 18
        static let imageIconSize: CGFloat = 36
        static let addButtonWidth: CGFloat = 128
        static let deleteTitle = "Удалить"
        static let addTitle = "Добавить"
    }
    
    static let idetifier = "ContactTableViewCell"
    var clickButton: ((ContactType) -> ())?
    var saveType: ContactType?
    
    private let imageIcon = UIImageView().apply {
        $0.image = UIImage(named: "x")
        $0.layer.cornerRadius = ConstantValues.imageIcon
        $0.backgroundColor = .white
    }
    
    private var name = UILabel().apply {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: ConstantValues.nameSize)
        $0.textColor = .white
    }
    
    private let phoneNumber = UILabel().apply {
        $0.font = .systemFont(ofSize: ConstantValues.phoneNumberSize)
        $0.textColor = .white
    }
    
    private let stackViewInfo = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = ConstantValues.stacViewSpacing
    }
    
     let addButton = UIButton().apply {
         $0.titleLabel?.font = .boldSystemFont(ofSize: ConstantValues.nameSize)
         $0.layer.cornerRadius = ConstantValues.cornerRadius
         $0.layer.borderWidth = ConstantValues.addButtonBorderWidth
}
    
    private let stackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = ConstantValues.phoneNumberSize
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
        setupConstraints()
        addButton.addTarget(self, action: #selector(addOrDelete(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        imageIcon.image = nil
//        name.text = nil
//        change(button: addButton, type: nil)
//        phoneNumber.text = nil
//    }
    
    @objc func addOrDelete(_ sender: UIButton) {
        guard let saveT = saveType else { return }
        clickButton?(saveT)
        if saveType == .add {
            saveType = .delete
            UserDefaults.standard.set(true, forKey: "contactAdded")
        }else {
            saveType = .add
            UserDefaults.standard.removeObject(forKey: "contactAdded")
        }
        saveType = (saveT == .add) ? .delete : .add
            
        change(button: addButton, type: saveType)
    }
    
    func configure(model: ContactModel) {
        name.text = model.name
        phoneNumber.text = model.phoneNumber
        imageIcon.image = UIImage(named: model.imgIcon)
        saveType = model.typeOfContact
        change(button: addButton, type: model.typeOfContact)
    }
    
    func change(button: UIButton, type: ContactType?) {
        if type == .delete {
            button.setTitle(ConstantValues.deleteTitle, for: .normal)
            button.setImage(nil, for: .normal)
            button.backgroundColor = .mainBackground
            button.setTitleColor(.contactAddDeleteButton, for: .normal)
            button.layer.borderColor = UIColor.contactAddDeleteButton.cgColor
        }else if type == .add {
            button.setTitle(ConstantValues.addTitle, for: .normal)
            button.setImage(UIImage(named: "plus"), for: .normal)
            button.setTitleColor(.mainBackground, for: .normal)
            button.imageEdgeInsets.right = ConstantValues.edgesInset
            button.backgroundColor = .contactAddDeleteButton
        }
    }
}

// MARK: - setupViews, setupConstaints
private extension ContactTableViewCell {
    func setupViews(){
        contentView.addSubview(stackView)
        [name, phoneNumber].forEach { i in
            stackViewInfo.addArrangedSubview(i)
        }
        [imageIcon, stackViewInfo, addButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(ConstantValues.phoneNumberSize)
            make.bottom.equalToSuperview().inset(ConstantValues.phoneNumberSize)
            make.leading.equalToSuperview().offset(ConstantValues.stackViewLeading)
        }
        imageIcon.snp.makeConstraints { make in
            make.size.equalTo(ConstantValues.imageIconSize)
        }
        addButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(ConstantValues.addButtonWidth)
        }
    }
}

import UIKit

class ContactTableViewCell: UITableViewCell {
    static let idetifier = "ContactTableViewCell"
    var clickButton: ((String) -> ())?
    var saveType: ContactType?
    
    private let imageIcon = UIImageView().apply {
        $0.image = UIImage(named: "x")
        $0.layer.cornerRadius = 18
        $0.backgroundColor = .white
    }
    
    private var name = UILabel().apply {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .white
    }
    
    private let phoneNumber = UILabel().apply {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let stackViewInfo = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.spacing = 2
    }
    
     let addButton = UIButton().apply {
        $0.setTitle("Добавить", for: .normal)
        $0.setImage(UIImage(named: "plus"), for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.setTitleColor(.mainBackground, for: .normal)
        $0.imageEdgeInsets.right = 6
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.backgroundColor = .contactAddDeleteButton
        $0.addTarget(self, action: #selector(addOrDelete(_:)), for: .touchUpInside)
    }
    
    private let stackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 12
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageIcon.image = nil
        name.text = nil
        change(button: addButton, type: nil)
        phoneNumber.text = nil
    }
    
    @objc func addOrDelete(_ sender: UIButton) {
        print("ADD or Delete contact")
        clickButton?("Aruzhan")
//        change(button: addButton, type: saveType)
    }
    
    func configure(model: ContactModel) {
        name.text = model.name
        phoneNumber.text = model.phoneNumber
        imageIcon.image = UIImage(named: model.imgIcon)
        saveType = model.typeOfContact
        
        
        change(button: addButton, type: saveType)
        
//        if model.typeOfContact == .delete {
//            print("type delete")
//            addButton.setTitle("Удалить", for: .normal)
//            addButton.setImage(nil, for: .normal)
//            addButton.backgroundColor = .mainBackground
//            addButton.setTitleColor(.contactAddDeleteButton, for: .normal)
//            addButton.layer.borderColor = UIColor.contactAddDeleteButton.cgColor
//        }
    }
    
    func change(button: UIButton, type: ContactType?) {
        if type == .delete {
            print("type delete")
            button.setTitle("Удалить", for: .normal)
            button.setImage(nil, for: .normal)
            button.backgroundColor = .mainBackground
            button.setTitleColor(.contactAddDeleteButton, for: .normal)
            button.layer.borderColor = UIColor.contactAddDeleteButton.cgColor
        }
    }
}

// MARK: - setupViews, setupConstaints
private extension ContactTableViewCell {
    func setupViews(){
        addSubview(stackView)
//        addSubview(addButton)
        
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
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(16)
//            make.trailing.equalToSuperview().inset(16)
        }
        
        imageIcon.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
//            make.leading.equalTo(stackView.snp.trailing).offset(16)
//            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(128)
        }
    }
}

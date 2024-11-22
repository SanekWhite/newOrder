//
//  PromoView.swift
//  newOrder
//
//  Created by Александр Белый on 13.11.2024.
//
import UIKit

class PromoView: UIView {
    var promo: PromoViewModel!
    var footerView: FooterView?
    var viewModeling =  ViewModel()
    
    
    
    // Элементы интерфейса для отображения промокода
    private let titleLabel = UILabel()
    private let discountLabel = UILabel()
    private let endDateLabel = UILabel()
    private let infoLabel = UILabel()
    private let actionPromoOneOrder2 = UILabel()
    private let percentView = UIView()
    //private let promocodes1Switch = UISwitch()
    lazy var promoCode1Switch: UISwitch = {
           let switcher = UISwitch()
           switcher.addTarget(self, action: #selector(promoCode1SwitchToggled), for: .valueChanged)
           return switcher
       }()
    static var activeSwitchCount = 0
    // Основное представление промокода
    private lazy var viewDesk: UIView = {
        let deskView = UIView()
        deskView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)// Цвет фона для viewDesk
        deskView.layer.cornerRadius = 12
        return deskView
    }()
    
    
    
    
    
    convenience init(promo: PromoViewModel, footerView: FooterView) {
        self.init(frame: .zero)
        self.promo = promo
        self.footerView = footerView
        setupView()
        setupConstraints()
        configure(with: promo)
        
        
    }
    
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Настройка и добавление subviews
    private func setupView() {
        addSubview(viewDesk)
        
        // Настройка titleLabel
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .black
        viewDesk.addSubview(titleLabel)
        
        endDateLabel.font = .systemFont(ofSize: 14)
        endDateLabel.textColor = .lightGray
        viewDesk.addSubview(endDateLabel)
        
        
        infoLabel.font = .systemFont(ofSize: 12)
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        percentView.addSubview(infoLabel)
        
        
        actionPromoOneOrder2.textColor = .gray
        actionPromoOneOrder2.font = UIFont.systemFont(ofSize: 12)
        actionPromoOneOrder2.numberOfLines = 0
        actionPromoOneOrder2.lineBreakMode = .byWordWrapping
        viewDesk.addSubview(actionPromoOneOrder2)
        
        
        percentView.backgroundColor = UIColor(red: 0/255, green: 183/255, blue: 117/255, alpha: 1)
        percentView.layer.cornerRadius = 10
        viewDesk.addSubview(percentView)
        
        
        promoCode1Switch.isOn = false
        promoCode1Switch.onTintColor = UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1)
        viewDesk.addSubview(promoCode1Switch)
        //promoCode1Switch.addTarget(self, action: #selector(promoCode1SwitchToggled(_:)), for: .valueChanged)
    }
    
    @objc func promoCode1SwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            
             if PromoView.activeSwitchCount < 2 {
                 PromoView.activeSwitchCount += 1
             } else {
                
                 sender.setOn(false, animated: true)
                 print("Максимум два свитчера могут быть активными.")
                 return
             }
         } else {
             
             PromoView.activeSwitchCount -= 1
         }
        
         // Обновляем данные о промокоде
         if let promo = promo, let firstPromoCode = promo.promocodes.first {
             var promoCode = firstPromoCode
             promoCode.active = sender.isOn
             
             footerView?.setUpUpdate()
    
         }
        
        
    }
      
     
    
    
    // Установка ограничений
    private func setupConstraints() {
        viewDesk.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewDesk).offset(12)
            make.left.equalTo(viewDesk).offset(20)
          
        }

        
        endDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(viewDesk).offset(20)
        }
        
        actionPromoOneOrder2.snp.makeConstraints { make in
            make.top.equalTo(endDateLabel.snp.bottom).offset(10)
            make.left.equalTo(viewDesk).offset(20)
            make.right.equalTo(viewDesk).offset(-10)
        }
        
        percentView.snp.makeConstraints { make in
            make.top.equalTo(viewDesk.snp.top).offset(12)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.width.equalTo(35)
            make.height.equalTo(20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(percentView)
            make.centerY.equalTo(percentView)
        }
        
        promoCode1Switch.snp.makeConstraints { make in
            make.top.equalTo(viewDesk.snp.top).offset(21)
            make.right.equalTo(viewDesk.snp.right).inset(20)
        }
      
    }
 
    // Конфигурация данных на основе модели
    private func configure(with promo: PromoViewModel) {
        let promo = promo.promocodes[0]
        titleLabel.text = promo.title
        discountLabel.text = "\(promo.percent)%"
        infoLabel.text = promo.info ?? ""
        actionPromoOneOrder2.text = promo.titleOneOrder
        
        if let formattedDate = formattedEndDate(for: promo) {
            endDateLabel.text = formattedDate
        } else {
            endDateLabel.text = "Дата не указана"
        }
        
    }
    
    func formattedEndDate(for promocode: PromoViewModel.Promocode) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        return "По \(dateFormatter.string(from: promocode.endDate))"
    }
    
    
}

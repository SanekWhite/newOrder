//
//  ViewController.swift
//  newOrder
//
//  Created by Александр Белый on 27.10.2024.
//

import UIKit
import SnapKit

class ViewModel {
    var viewModels: [PromoViewModel] = [.init(screenTitle: "",
                                              promocodes: .init(arrayLiteral: .init(title: "Hello", titleOneOrder: "Промокод действует на первый заказ в приложении", percent: 5, endDate: Date(), info: "-5%", active: false)),
                                              products: .init(arrayLiteral: .init(price: 2500, title: "Продукт 1")), paymentDiscount: 10, baseDiscount: 10),
                                        .init(screenTitle: "",
                                              promocodes: .init(arrayLiteral: .init(title: "Hello", titleOneOrder: "Промокод действует на первый заказ в приложении", percent: 5, endDate: Date(), info: "-5%", active: false)),
                                              products: .init(arrayLiteral: .init(price: 2500, title: "Продукт 1")), paymentDiscount: 10, baseDiscount: 10),
                                        .init(screenTitle: "",
                                              promocodes: .init(arrayLiteral: .init(title: "Hello", titleOneOrder: "Промокод действует на первый заказ в приложении", percent: 5, endDate: Date(), info: "-5%", active: false)),
                                              products: .init(arrayLiteral: .init(price: 2500, title: "Продукт 1")), paymentDiscount: 10, baseDiscount: 10),
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
    ]
    
    
    
    
}

class ViewController: UIViewController {
    let colorRedLight = UIColor(red: 255/255, green: 70/255, blue: 17/255, alpha: 0.1)
    let colorGrayLight = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    let orangeRed = UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1)
    let greenDark = UIColor(red: 23/255, green: 150/255, blue: 0/255, alpha: 1)
    
    let viewModel = ViewModel()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Оформление заказа"
        view.addSubview(scrollView)
        
        
        
        updateAllViews()
        
    }
    
    func updateAllViews() {
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        scrollView.addSubview(containerView)
        // Constraints для HeaderView
        
        
        
        containerView.subviews.forEach { $0.removeFromSuperview() }
        let header = HeaderView()
        containerView.addSubview(header)
        
        
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(192)
        }
        
        
        
        
        
        var previousView: UIView?
        viewModel.viewModels.forEach { promoViewModel in
            let view = PromoView(promo: promoViewModel)
            view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(view)
            
            view.snp.makeConstraints { make in
                
                make.left.right.equalTo(containerView).inset(16)
                make.height.equalTo(90)
                
                
            }
            
            
            
            if previousView == nil {
                // Первый PromoView
                view.snp.makeConstraints { make in
                    make.top.equalTo(header.snp.bottom).offset(16)  // Расстояние от header
                }
            } else {
                // Последующие PromoView
                view.snp.makeConstraints { make in
                    make.top.equalTo(previousView!.snp.bottom).offset(8)
                }
            }
            
            
            previousView = view
        }
        
        
        
        let footer = FooterView()
        footer.backgroundColor = colorGrayLight
        containerView.addSubview(footer)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.left.equalTo(scrollView.contentLayoutGuide.snp.left)
            make.right.equalTo(scrollView.contentLayoutGuide.snp.right)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
        
        
        footer.snp.makeConstraints { make in
            //   make.top.equalTo(previousView!.snp.bottom).offset(16)
            make.left.right.equalTo(containerView)
            make.height.equalTo(350) // Высота footer
            make.bottom.equalTo(containerView.snp.bottom) // Закрепляем к низу containerView
        }
        
        
        if previousView != nil {
            // добавляем constraints к последнему промокоду
            footer.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 16).isActive = true
        } else {
            // добавляем constraints header
            footer.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 16).isActive = true
        }
    }
}

struct PromoViewModel {
    
    struct Promocode {
        
        let title: String
        let titleOneOrder: String
        let percent: Int
        var endDate = Date()
        let info: String?
        var active: Bool
        
        
    }
    
    struct Product {
        
        let price: Double
        let title: String
        
    }
    
    var screenTitle: String
    var promocodes: [Promocode]
    
    
    
    var products: [Product]
    let paymentDiscount: Double?
    let baseDiscount: Double?
    
    
}



class PromoView: UIView {
    var promo: PromoViewModel!
    var footerView = FooterView()
    var viewModeling =  ViewModel()
    func setUpUpdate() {
        let totalPriceProduct = viewModeling.viewModels.flatMap { $0.products }.reduce(0) { $0 + $1.price }
        let totalPriceProductInt = Int(totalPriceProduct)
        footerView.priceForTwoItemsTotalText.text = "\(totalPriceProductInt) ₽"

        // Получаем значение скидок
        let paymentDiscount = viewModeling.viewModels.compactMap { $0.paymentDiscount }.first ?? 0
        var totalPaymentDisc: Double = 0
        if paymentDiscount > 0 {
            totalPaymentDisc = Double(totalPriceProduct * (paymentDiscount / 100))
            let totalPaymentDiscInt = Int(totalPaymentDisc)
            footerView.paymentTotalText.text = "\(-totalPaymentDiscInt) ₽"
        }

        // Получаем значение базовой скидки
        let baseDiscount = viewModeling.viewModels.compactMap { $0.baseDiscount }.first ?? 0
        var totalBaseDisc: Double = 0
        if baseDiscount > 0 {
            totalBaseDisc = Double(totalPriceProduct * (baseDiscount / 100))
            let totalBaseDiscInt = Int(totalBaseDisc)
            footerView.discountsTotalText.text = "\(-totalBaseDiscInt) ₽"
        }

        // Применение активных промокодов
        var totalPromocodeDiscount: Double = 0
        let activePromocodes = viewModeling.viewModels.flatMap { $0.promocodes }.filter { $0.active }
        for promocode in activePromocodes {
            let discount = totalPriceProduct * (Double(promocode.percent) / 100)
            totalPromocodeDiscount += discount
        }

        footerView.promoCodeTotalText.text = "\(-Int(totalPromocodeDiscount)) ₽"

        // Обновление итоговой стоимости
        let finalTotal = totalPriceProduct - (totalPaymentDisc + totalBaseDisc + totalPromocodeDiscount)
        footerView.total.text = "\(Int(finalTotal)) ₽"
    }
    
    // Элементы интерфейса для отображения промокода
    private let titleLabel = UILabel()
    private let discountLabel = UILabel()
    private let endDateLabel = UILabel()
    private let infoLabel = UILabel()
    private let actionPromoOneOrder2 = UILabel()
    private let percentView = UIView()
    private let promocodes1Switch = UISwitch()
    static var activeSwitchCount = 0
    // Основное представление промокода
    private lazy var viewDesk: UIView = {
        let deskView = UIView()
        deskView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)// Цвет фона для viewDesk
        deskView.layer.cornerRadius = 12
        return deskView
    }()
    
    
    
    
    
    convenience init(promo: PromoViewModel) {
        self.init(frame: .zero)
        self.promo = promo
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
        
        
        promocodes1Switch.isOn = false
        promocodes1Switch.onTintColor = UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1)
        viewDesk.addSubview(promocodes1Switch)
        promocodes1Switch.addTarget(self, action: #selector(promoCode1SwitchToggled(_:)), for: .valueChanged)
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
             
             // Обновление интерфейса
             configure(with: promo)
             setUpUpdate()
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
        
        promocodes1Switch.snp.makeConstraints { make in
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



class HeaderView: UIView {
    
    let mobileDivider = UIView()
    let titleDesk = UIView()
    let titleDeskText = UILabel()
    let oneProductOnePromo = UILabel()
    let buttonPromocode = UIButton(type: .system)
    let imageView = UIView()
    let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Настроим mobileDivider
        mobileDivider.layer.shadowColor = UIColor.gray.cgColor
        mobileDivider.layer.shadowOpacity = 0.1
        mobileDivider.layer.shadowOffset = CGSize(width: 0, height: 2)
        mobileDivider.layer.shadowRadius = 3
        mobileDivider.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        mobileDivider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mobileDivider)
        
        // Настроим titleDesk и titleDeskText
        titleDesk.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleDesk)
        
        titleDeskText.text = "Промокоды"
        titleDeskText.textColor = .black
        titleDeskText.font = .systemFont(ofSize: 24)
        titleDeskText.numberOfLines = 0
        titleDeskText.lineBreakMode = .byWordWrapping
        titleDeskText.translatesAutoresizingMaskIntoConstraints = false
        titleDesk.addSubview(titleDeskText)
        
        // Настроим oneProductOnePromo
        oneProductOnePromo.text = "На один товар можно применить только один промокод"
        oneProductOnePromo.textColor = .gray
        oneProductOnePromo.font = .systemFont(ofSize: 14)
        oneProductOnePromo.numberOfLines = 0
        oneProductOnePromo.lineBreakMode = .byWordWrapping
        oneProductOnePromo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(oneProductOnePromo)
        
        // Настроим buttonPromocode
        buttonPromocode.backgroundColor = UIColor(red: 255/255, green: 70/255, blue: 17/255, alpha: 0.1) // Цвет кнопки
        buttonPromocode.setTitle("Применить промокод", for: .normal)
        buttonPromocode.setTitleColor(UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1), for: .normal)
        buttonPromocode.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        buttonPromocode.layer.cornerRadius = 12
        buttonPromocode.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonPromocode)
        
        // Настроим imageView и image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        buttonPromocode.addSubview(imageView)
        
        image.image = UIImage(named: "shape") // Имя изображения для image
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(image)
    }
    
    private func setupConstraints() {
        
        
        // Constraints для mobileDivider
        mobileDivider.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.right.equalTo(self)
            make.height.equalTo(16)
        }
        
        // Constraints для titleDesk и titleDeskText
        NSLayoutConstraint.activate([
            titleDesk.topAnchor.constraint(equalTo: mobileDivider.bottomAnchor, constant: 24),
            titleDesk.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            titleDesk.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            titleDesk.heightAnchor.constraint(equalToConstant: 82),
            
            titleDeskText.topAnchor.constraint(equalTo: titleDesk.topAnchor, constant: 1),
            titleDeskText.leftAnchor.constraint(equalTo: titleDesk.leftAnchor, constant: 1),
            titleDeskText.rightAnchor.constraint(equalTo: titleDesk.rightAnchor, constant: -1)
        ])
        
        // Constraints для oneProductOnePromo
        oneProductOnePromo.snp.makeConstraints { make in
            make.top.equalTo(titleDeskText.snp.bottom).offset(10)
            make.left.equalTo(titleDesk)
            make.right.equalTo(titleDesk)
        }
        
        // Constraints для buttonPromocode
        buttonPromocode.snp.makeConstraints { make in
            make.top.equalTo(titleDesk.snp.bottom).offset(16)
            make.left.equalTo(titleDesk)
            make.right.equalTo(titleDesk)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        // Constraints для imageView
        imageView.snp.makeConstraints { make in
            make.top.equalTo(buttonPromocode.snp.top).offset(19)
            make.left.equalTo(buttonPromocode.snp.left).offset(75)
            make.width.equalTo(20)
            make.height.equalTo(16)
        }
    }
    
    
}

class FooterView: UIView {
    
    var viewModeling =  ViewModel()
    
    
    var promo: PromoViewModel?
    
  
    private lazy var summTable: UIView = {
        let summTable = UIView()
        summTable.backgroundColor = .clear
        return summTable
    }()
    
    // Элементы внутри summTable
     lazy var priceForTwoItems: UILabel = createLabel(text: "Цена за два товара", fontSize: 14, color: .black)
     lazy var priceForTwoItemsTotalText: UILabel = createLabel(text: "0 ₽", fontSize: 14, color: .black)
     lazy var discountsText: UILabel = createLabel(text: "Скидки", fontSize: 14, color: .black)
     lazy var discountsTotalText: UILabel = createLabel(text: "0 ₽", fontSize: 14, color: .red)
     lazy var promocodeText: UILabel = createLabel(text: "Промокоды", fontSize: 14, color: .black)
     lazy var promoCodeTotalText: UILabel = createLabel(text: "0 ₽", fontSize: 14, color: UIColor(red: 23/255, green: 150/255, blue: 0/255, alpha: 1))
     lazy var paymentMethodText: UILabel = createLabel(text: "Способ оплаты", fontSize: 14, color: .black)
     lazy var paymentTotalText: UILabel = createLabel(text: "0 ₽", fontSize: 14, color: .black)
     lazy var totalText: UILabel = createLabel(text: "Итого", fontSize: 18, color: .black)
     lazy var total: UILabel = createLabel(text: "0 ₽", fontSize: 18, color: .black)
    
    private lazy var willPlaceAnOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оформить заказ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 12
        
        return button
        
    }()
    
    
    
    private lazy var termsOfOffer: UILabel = {
        let label = UILabel()
        label.text = "Нажимая на кнопку Оформить заказ, Вы соглашаетесь с Условиями оферты"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        updateTotalPrice()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(summTable)
        
        [priceForTwoItems, priceForTwoItemsTotalText, discountsText, discountsTotalText,
         promocodeText, promoCodeTotalText, paymentMethodText, paymentTotalText,
         totalText, total, willPlaceAnOrderButton, termsOfOffer].forEach {
            summTable.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        summTable.translatesAutoresizingMaskIntoConstraints = false
        summTable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().inset(158)
        }
        
        priceForTwoItems.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(1)
        }
        
        priceForTwoItemsTotalText.snp.makeConstraints { make in
            make.top.equalTo(priceForTwoItems)
            make.right.equalToSuperview().offset(-1)
        }
        
        discountsText.snp.makeConstraints { make in
            make.top.equalTo(priceForTwoItems.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(1)
        }
        
        discountsTotalText.snp.makeConstraints { make in
            make.top.equalTo(priceForTwoItemsTotalText.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-1)
        }
        
        promocodeText.snp.makeConstraints { make in
            make.top.equalTo(discountsText.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(1)
        }
        
        promoCodeTotalText.snp.makeConstraints { make in
            make.top.equalTo(discountsTotalText.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-1)
        }
        
        paymentMethodText.snp.makeConstraints { make in
            make.top.equalTo(promocodeText.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(1)
        }
        
        paymentTotalText.snp.makeConstraints { make in
            make.top.equalTo(promoCodeTotalText.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-1)
        }
        
        totalText.snp.makeConstraints { make in
            make.top.equalTo(paymentMethodText.snp.bottom).offset(33)
            make.left.equalToSuperview().offset(1)
        }
        
        total.snp.makeConstraints { make in
            make.top.equalTo(paymentTotalText.snp.bottom).offset(33)
            make.right.equalToSuperview().offset(-1)
        }
        
        willPlaceAnOrderButton.snp.makeConstraints { make in
            make.top.equalTo(summTable.snp.bottom).offset(16)
            make.left.equalTo(totalText)
            make.right.equalTo(total)
            make.height.equalTo(54)
            
        }
        
        termsOfOffer.snp.makeConstraints { make in
            make.top.equalTo(willPlaceAnOrderButton.snp.bottom).offset(16)
            make.left.equalTo(willPlaceAnOrderButton)
            make.right.equalTo(willPlaceAnOrderButton)
        }
        
        willPlaceAnOrderButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
   
    
   
    
    
    @objc func buttonTapped(_ sender: UIButton) {
        print("Button tapped!")
        sender.backgroundColor = .green 
    }
    private func createLabel(text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: fontSize)
        label.textColor = color
        return label
    }
    func updateTotalPrice() {
        
        let productTotal = viewModeling.viewModels.flatMap { $0.products }.reduce(0) { $0 + $1.price }
        priceForTwoItemsTotalText.text = "\(productTotal) ₽"
        
        guard productTotal != 0 else {
            let error3 = UIButton(type: .custom)
            error3.setTitle("У продукта стоимость должна быть больше 0", for: .normal)
            error3.setTitleColor(.white, for: .normal)
            error3.titleLabel?.lineBreakMode = .byWordWrapping
            error3.titleLabel?.numberOfLines = 0
            error3.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            error3.backgroundColor = .red
            error3.layer.cornerRadius = 20
            error3.translatesAutoresizingMaskIntoConstraints = false
            summTable.addSubview(error3)
            
            NSLayoutConstraint.activate([
                error3.centerXAnchor.constraint(equalTo: summTable.centerXAnchor),
                error3.centerYAnchor.constraint(equalTo: summTable.centerYAnchor),
                
                error3.widthAnchor.constraint(equalToConstant: 360),
                error3.heightAnchor.constraint(equalToConstant: 100)
                
            ])
            error3.addTarget(self, action: #selector(error3ButtonTapped), for: .touchUpInside)
            
            return
        }
        
        let paymentDiscount = viewModeling.viewModels.compactMap { $0.paymentDiscount }.first ?? 0
        var totalPaymentDisc: Double = 0
        if paymentDiscount > 0 {
            totalPaymentDisc = Double(productTotal * (paymentDiscount / 100))
            let totalPaymentDiscInt = Int(totalPaymentDisc)
            paymentTotalText.text = "\(-totalPaymentDiscInt) ₽"
        }
        
        // Получаем значение базовой скидки
        let baseDiscount = viewModeling.viewModels.compactMap { $0.baseDiscount }.first ?? 0
        var totalBaseDisc: Double = 0
        if baseDiscount > 0 {
            totalBaseDisc = Double(productTotal * (baseDiscount / 100))
            let totalBaseDiscInt = Int(totalBaseDisc)
            discountsTotalText.text = "\(-totalBaseDiscInt) ₽"
        }
        
        // Подсчитываем итог с учетом скидок
        let finalTotal = productTotal - (totalPaymentDisc + totalBaseDisc)
        let finalTotalInt = Int(finalTotal)
        total.text = "\(finalTotalInt) ₽"
        
    }
    
    func setUpUpdate() {
        let totalPriceProduct = viewModeling.viewModels.flatMap { $0.products }.reduce(0) { $0 + $1.price }
        let totalPriceProductInt = Int(totalPriceProduct)
        priceForTwoItemsTotalText.text = "\(totalPriceProductInt) ₽"

        // Получаем значение скидок
        let paymentDiscount = viewModeling.viewModels.compactMap { $0.paymentDiscount }.first ?? 0
        var totalPaymentDisc: Double = 0
        if paymentDiscount > 0 {
            totalPaymentDisc = Double(totalPriceProduct * (paymentDiscount / 100))
            let totalPaymentDiscInt = Int(totalPaymentDisc)
            paymentTotalText.text = "\(-totalPaymentDiscInt) ₽"
        }

        // Получаем значение базовой скидки
        let baseDiscount = viewModeling.viewModels.compactMap { $0.baseDiscount }.first ?? 0
        var totalBaseDisc: Double = 0
        if baseDiscount > 0 {
            totalBaseDisc = Double(totalPriceProduct * (baseDiscount / 100))
            let totalBaseDiscInt = Int(totalBaseDisc)
            discountsTotalText.text = "\(-totalBaseDiscInt) ₽"
        }

        // Применение активных промокодов
        var totalPromocodeDiscount: Double = 0
        let activePromocodes = viewModeling.viewModels.flatMap { $0.promocodes }.filter { $0.active }
        for promocode in activePromocodes {
            let discount = totalPriceProduct * (Double(promocode.percent) / 100)
            totalPromocodeDiscount += discount
        }

        promoCodeTotalText.text = "\(-Int(totalPromocodeDiscount)) ₽"

        // Обновление итоговой стоимости
        let finalTotal = totalPriceProduct - (totalPaymentDisc + totalBaseDisc + totalPromocodeDiscount)
        total.text = "\(Int(finalTotal)) ₽"
    }
    
    @objc func error3ButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            UIView.animate(withDuration: 0.5, animations: {
                sender.alpha = 0.5
                sender.backgroundColor = .clear
            }) { _ in
                
                sender.removeFromSuperview()
            }
        }
    }
    @objc func errorButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            UIView.animate(withDuration: 0.5, animations: {
                sender.alpha = 0.5
                sender.backgroundColor = .clear
            }) { _ in
                
                sender.removeFromSuperview()
            }
        }
    }
}


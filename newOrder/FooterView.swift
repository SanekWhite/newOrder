//
//  FooterView.swift
//  newOrder
//
//  Created by Александр Белый on 13.11.2024.
//

import UIKit

class FooterView: UIView {
    
    var viewModeling =  ViewModel()
    var promo: PromoViewModel?
    var promoView = PromoView()
  
    private lazy var summTable: UIView = {
        let summTable = UIView()
        summTable.backgroundColor = .clear
        return summTable
    }()
    
    // Элементы внутри summTable
    private lazy var priceForTwoItems: UILabel = createLabel(text: "Цена за два товара", fontSize: 14, color: .black)
    private lazy var priceForTwoItemsTotalText: UILabel = createLabel(text: "0 ₽", fontSize: 14, color: .black)
    private lazy var discountsText: UILabel = createLabel(text: "Скидки", fontSize: 14, color: .black)
    private lazy var discountsTotalText: UILabel = createLabel(text: "0 ₽", fontSize: 14, color: .red)
    private lazy var promocodeText: UILabel = createLabel(text: "Промокоды", fontSize: 14, color: .black)
    private lazy var promoCodeTotalText: UILabel = createLabel(text: "0 ₽", fontSize: 14, color: UIColor(red: 23/255, green: 150/255, blue: 0/255, alpha: 1))
    private lazy var paymentMethodText: UILabel = createLabel(text: "Способ оплаты", fontSize: 14, color: .black)
    private lazy var paymentTotalText: UILabel = createLabel(text: "0 ₽", fontSize: 14, color: .black)
    private lazy var totalText: UILabel = createLabel(text: "Итого", fontSize: 18, color: .black)
    private lazy var total: UILabel = createLabel(text: "0 ₽", fontSize: 18, color: .black)
    
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
            make.bottom.equalTo(willPlaceAnOrderButton.snp.bottom)
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
            make.top.equalTo(total.snp.bottom).offset(16)
            make.left.equalTo(summTable.snp.left)
            make.right.equalTo(summTable.snp.right)
            make.height.equalTo(54)
            
        }
        
        termsOfOffer.snp.makeConstraints { make in
            make.top.equalTo(willPlaceAnOrderButton.snp.bottom).offset(16)
            make.left.equalTo(willPlaceAnOrderButton)
            make.right.equalTo(willPlaceAnOrderButton)
        }
        
        willPlaceAnOrderButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
   
    
   
    
    
    @objc private func buttonTapped(_ sender: UIButton) {
        print("Button tapped!")
        //sender.backgroundColor = .green
    }
    private func createLabel(text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: fontSize)
        label.textColor = color
        return label
    }
    private func updateTotalPrice() {
        
        
        let productTotal = viewModeling.viewModels.flatMap { $0.products }.reduce(0) { $0 + $1.price }
        priceForTwoItemsTotalText.text = "\(Int(productTotal)) ₽"
        
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
          
        print("setUpUpdate вызывается")
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
      //  let promoFu = viewModeling.viewModels.flatMap { $0.promocodes}.reduce(0) { $0 + $1.}
        
        // Применение активных промокодов
        var totalPromocodeDiscount: Double = 0
        let activePromocodes = viewModeling.viewModels.flatMap { $0.promocodes }.filter { $0.active }
        
        for promocode in activePromocodes {
            let discount = totalPriceProduct * (Double(promocode.percent) / 100)
            totalPromocodeDiscount += discount
            
        }

        promoCodeTotalText.text = "\(Int(-totalPromocodeDiscount)) ₽"

        // Обновление итоговой стоимости
        let finalTotal = totalPriceProduct - (totalPaymentDisc + totalBaseDisc + totalPromocodeDiscount)
        total.text = "\(Int(finalTotal)) ₽"
        
    }
    
    @objc private func error3ButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            UIView.animate(withDuration: 0.5, animations: {
                sender.alpha = 0.5
                sender.backgroundColor = .clear
            }) { _ in
                
                sender.removeFromSuperview()
            }
        }
    }
    @objc private func errorButtonTapped(_ sender: UIButton) {
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

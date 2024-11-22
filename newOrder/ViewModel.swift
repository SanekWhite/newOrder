//
//  ViewModel.swift
//  newOrder
//
//  Created by Александр Белый on 13.11.2024.
//
import Foundation

class ViewModel {
    var viewModels: [PromoViewModel] = [.init(screenTitle: "",
                                              promocodes: .init(arrayLiteral: .init(title: "Hello", titleOneOrder: "Промокод действует на первый заказ в приложении", percent: 5, endDate: Date(), info: "-5%", active: true)),
                                              products: .init(arrayLiteral: .init(price: 2500, title: "Продукт 1")), paymentDiscount: 10, baseDiscount: 10),
                                        .init(screenTitle: "",
                                              promocodes: .init(arrayLiteral: .init(title: "Hello", titleOneOrder: "Промокод действует на первый заказ в приложении", percent: 5, endDate: Date(), info: "-5%", active: true)),
                                              products: .init(arrayLiteral: .init(price: 2500, title: "Продукт 1")), paymentDiscount: 10, baseDiscount: 10),
                                        .init(screenTitle: "",
                                              promocodes: .init(arrayLiteral: .init(title: "Hello", titleOneOrder: "Промокод действует на первый заказ в приложении", percent: 5, endDate: Date(), info: "-5%", active: true)),
                                              products: .init(arrayLiteral: .init(price: 2500, title: "Продукт 1")), paymentDiscount: 10, baseDiscount: 10),
                                        
                                        
    ]
    
}

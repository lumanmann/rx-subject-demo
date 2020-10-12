//
//  DemoViewModel.swift
//  rxsubjects
//
//  Created by Goons on 2020/10/12.
//

import Foundation
import RxSwift

class DemoViewModel {
    let numberSubject = PublishSubject<Int>()
    
    func callAPI() {
        numberSubject.onNext(Int.random(in: 0...100))
    }
}

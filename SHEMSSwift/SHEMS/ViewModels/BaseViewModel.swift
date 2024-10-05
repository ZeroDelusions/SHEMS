//
//  BaseViewModel.swift
//  SHEMS
//
//  Created by Косоруков Дмитро on 21/09/2024.
//

import Foundation
import SwiftUI
import Combine

func doNothing<T>(t: T) -> T { return t }

class BaseViewModel<T: IdentifiedItem>: ObservableObject, APIErrorHandler {
    @Published var items: [T] = []
    @Published var apiError: APIError?
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchItem(
        using fetchPublisher: AnyPublisher<T, APIError>,
        completionHandler: ((CompletionHandler) -> Void)? = nil,
        successHandler: ((T) -> [T])? = nil
    ) {
        fetchPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: completionHandler ?? handleCompletion(_:),
                receiveValue: { [weak self] items in
                    self?.items = successHandler?(items) ?? [items]
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchItems(
        using fetchPublisher: AnyPublisher<[T], APIError>,
        completionHandler: ((CompletionHandler) -> Void)? = nil,
        successHandler: (([T]) -> [T])? = nil
    ) {
        fetchPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: completionHandler ?? handleCompletion(_:),
                receiveValue: { [weak self] items in
                    self?.items = successHandler?(items) ?? items
                }
            )
            .store(in: &cancellables)
    }
    
    func addItem(
        using addPublisher: AnyPublisher<T, APIError>,
        completionHandler: ((CompletionHandler) -> Void)? = nil,
        successHandler: ((T) -> T)? = nil
    ) {
        addPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: completionHandler ?? handleCompletion(_:),
                receiveValue: { [weak self] newItem in
                    self?.items.append(successHandler?(newItem) ?? newItem)
                }
            )
            .store(in: &cancellables)
    }
    
    func updateItem(
        using addPublisher: AnyPublisher<T, APIError>,
        completionHandler: ((CompletionHandler) -> Void)? = nil,
        successHandler: ((T) -> T)? = nil
    ) {
        addPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: completionHandler ?? handleCompletion(_:),
                receiveValue: { [weak self] item in
                    if let oldItemIndex = self?.items.firstIndex(where: { $0.id == item.id }) {
                        self?.items[oldItemIndex] = successHandler?(item) ?? item
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteItem(
        using deletePublisher: AnyPublisher<T, APIError>,
        completionHandler: ((CompletionHandler) -> Void)? = nil,
        successHandler: ((T) -> T)? = nil
    ) {
        deletePublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: completionHandler ?? handleCompletion(_:),
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
}

extension BaseViewModel {
    typealias CompletionHandler = Subscribers.Completion<APIError>

    func handleCompletion(_ completion: CompletionHandler){
        if case .failure(let error) = completion {
            self.setError(error)
        }
    }
}


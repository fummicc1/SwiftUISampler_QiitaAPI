import Foundation
import SwiftUI
import Combine

final class ViewModel: BindableObject {
    var didChange = PassthroughSubject<ViewModel, Never>()
    
    var textName = "" {
        didSet {
            didChange.send(self)
        }
    }
    
    private(set) var qiitaList: [Qiita] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    private(set) var searchCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    deinit {
        searchCancellable?.cancel()
    }
    
    func search() {
        guard textName.isNotEmpty else {
            qiitaList = []
            return
        }
        var urlComponents = URLComponents(string: "https://qiita.com/api/v2/items")!
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: textName)
        ]
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let publisher = AnyPublisher<Data, Error> { subscriber in
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        subscriber.receive(completion: .failure(error))
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    _ = subscriber.receive(data)
                    subscriber.receive(completion: .finished)
                }
            }
            subscriber.receive(subscription: CancellSubscription(task.cancel))
            task.resume()
        }
        searchCancellable = publisher
            .decode(type: [Qiita].self, decoder: JSONDecoder())
            .replaceEmpty(with: [])
            .replaceError(with: [])
            .assign(to: \.qiitaList, on: self)
    }
}

extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

extension String {
    var isNotEmpty: Bool { !isEmpty }
}

final class CancellSubscription: Subscription {
    let cancellable: Cancellable
    
    init(_ cancell: @escaping () -> ()) {
        cancellable = AnyCancellable(cancell)
    }
    
    func request(_ demand: Subscribers.Demand) {
        
    }
    
    func cancel() {
        cancellable.cancel()
    }
}

extension JSONDecoder: TopLevelDecoder {}

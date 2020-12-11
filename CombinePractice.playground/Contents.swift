import Foundation
import Combine

enum WeatherError: Error {
    case weirdError
}

let weatherPublisher = PassthroughSubject<Int, WeatherError>()

let subscriber = weatherPublisher
    .filter({$0 > 25})
    .sink { (completion) in
        return
    } receiveValue: { (value) in
        print("It is \(value) degrees outside")
    }

let otherSubscriber = weatherPublisher.handleEvents { (subscription) in
    print("new subscription \(subscription)")
} receiveOutput: { (output) in
    print("new output \(output)")
} receiveCompletion: { (error) in
    print("subscription completed with potential error \(error)")
} receiveCancel: {
    print("subscription cancelled")
} receiveRequest: { (demand) in
    print("request recieved \(demand)")
}.sink { (completion) in
    print("request completed \(completion)")
} receiveValue: { (value) in
    print("new value \(value)")
}

weatherPublisher.send(10)
weatherPublisher.send(completion: Subscribers.Completion<WeatherError>.failure(.weirdError))
weatherPublisher.send(30)

import Foundation
@testable import ExchangeRates

class URLSessionMock: URLSessionProtocol {

  var url: URL?
  var task = URLSessionDataTaskMock()


  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    self.url = url
    task.completionHandler = completionHandler
    return task
  }

}

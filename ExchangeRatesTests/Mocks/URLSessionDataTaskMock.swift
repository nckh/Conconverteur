import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {

  var resumeWasCalled = false
  var resultData: Data?
  var resultURLResponse: URLResponse?
  var resultError: Error?
  var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?


  override init() {}

  override func resume() {
    completionHandler?(resultData, resultURLResponse, resultError)
    resumeWasCalled = true
  }

}

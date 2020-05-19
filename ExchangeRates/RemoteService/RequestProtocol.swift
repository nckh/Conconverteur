protocol RequestProtocol {

  typealias CompletionHandler = (Result<Data, Error>) -> Void

  func load(completionHandler: CompletionHandler?)

}

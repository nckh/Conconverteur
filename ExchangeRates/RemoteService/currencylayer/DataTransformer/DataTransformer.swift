protocol DataTransformer {

  associatedtype Input
  associatedtype Output

  func transform(_ input: Input) -> Output

}

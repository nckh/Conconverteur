import Foundation

/// An operation that executes a request to currencylayer API, then decodes the JSON response and
/// transforms it to another type.
class CurrencylayerOperation<DecodedResponse, Transformer, TransformedResponse>: QueryOperation<TransformedResponse> where
  DecodedResponse: Decodable,
  Transformer: DataTransformer,
  Transformer.Input == DecodedResponse,
  Transformer.Output == TransformedResponse {

  /// An abstract request.
  private let request: RequestProtocol

  /// A JSON decoder.
  private let decoder: JSONDecoder

  /// A transformation applied to the decoded response from the API.
  private let dataTransformer: Transformer


  /// Creates an operation that executes a request to currencylayer API, then decodes the JSON
  /// response and transforms it to another type.
  /// - Parameters:
  ///   - request: An abstract request.
  ///   - decoder: An optional JSON decoder. Pass a different one if specific decoding strategies
  ///   are required.
  ///   - dataTransformer: A transformation applied to the decoded response from the API.
  init(request: RequestProtocol, decoder: JSONDecoder = .init(), dataTransformer: Transformer) {
    self.request = request
    self.decoder = decoder
    self.dataTransformer = dataTransformer
  }

  override func main() {
    request.load { [weak self] result in
      self?.handleRequestResult(result)
    }
  }

  private func handleRequestResult(_ result: Result<Data, Error>) {
    switch result {
    case let .failure(error): finish(with: .failure(error))
    case let .success(data):
      do {
        let response = try decodeResponse(data: data)
        let transformedData = transformResponse(response)
        finish(with: .success(transformedData))

      } catch {
        do {
          // Converting to the success response format failed, attempt to convert to the error
          // response format.
          let errorResponse = try decodeError(data: data)
          finish(with: .failure(CurrencylayerOperationError.apiError(errorResponse.error)))

        } catch {
          finish(with: .failure(CurrencylayerOperationError.couldNotDecode))
        }
      }
    }
  }

  private func finish(with result: Result<TransformedResponse, Error>) {
    queryCompletionBlock?(result)
    finish()
  }

  private func decodeResponse(data: Data) throws -> DecodedResponse {
    try decoder.decode(DecodedResponse.self, from: data)
  }

  private func decodeError(data: Data) throws -> CurrencylayerErrorResponse {
    try decoder.decode(CurrencylayerErrorResponse.self, from: data)
  }

  private func transformResponse(_ response: DecodedResponse) -> TransformedResponse {
    dataTransformer.transform(response)
  }

}

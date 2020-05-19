/// An operation used to execute any kind of queries.
public class QueryOperation<T>: NKOperation {

  public typealias QueryCompletionBlock = (Result<T, Error>) -> Void

  /// The block executed after the query completes.
  public var queryCompletionBlock: QueryCompletionBlock?

}

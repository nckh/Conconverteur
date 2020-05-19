struct CurrencylayerErrorResponse: Decodable {

  let success: Bool
  let error: Error


  struct Error: Decodable {
    let code: Int
    let info: String
  }

}

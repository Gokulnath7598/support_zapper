enum ExceptionType{
  notFound,             // 404 Api Response
  internalServerError,  // 500 Api Response  
  connectionTimeout,    // Dio exception
  receiveTimeout,       // Dio exception
  sendTimeout,          // Dio exception
  unAuthorized,         // 401 Api Response
  unKnownDioException,  // Dio Exception
  unKnownException,     // Any Unknown Exception
  renderFlexOverflow,   // Renderflow error exception
  custom   // custom
}

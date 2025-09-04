enum StatusCode {
  ok(200),
  created(201),
  accepted(202),
  noContent(204),

  badRequest(400),
  unauthorized(401),
  forbidden(403),
  notFound(404),
  conflict(409),

  internalServerError(500),
  notImplemented(501),
  badGateway(502),
  serviceUnavailable(503),
  gatewayTimeout(504),
  noInternet(505),
  unknownError(506);

  final int code;

  const StatusCode(this.code);

  static StatusCode? fromCode(int? code) {
    try {
      if (code == null) {
        return StatusCode.unknownError;
      }
      return StatusCode.values.firstWhere((status) => status.code == code);
    } catch (_) {
      return null;
    }
  }
}

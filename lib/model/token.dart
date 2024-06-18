class Token {
  Token({
    this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token'] as String?);
  }

  final String? token;
}

class PaginationResponseDto {
  List<dynamic> body;
  int total;
  String page;
  int lastPage;

  PaginationResponseDto({
    required this.body,
    required this.total,
    required this.page,
    required this.lastPage,
  });

  factory PaginationResponseDto.fromJson(Map<String, dynamic> json) =>
      PaginationResponseDto(
        body: List<dynamic>.from(json["body"].map((x) => x)),
        total: json["total"],
        page: json["page"],
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "body": List<dynamic>.from(body.map((x) => x)),
        "total": total,
        "page": page,
        "last_page": lastPage,
      };
}

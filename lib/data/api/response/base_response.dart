class BaseResponse<T> {
  final String? message;
  final T? data;
  final dynamic errors; // can be String or Map depending on your backend

  BaseResponse({
    this.message,
    this.data,
    this.errors,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonFunction,
  ) {
    return BaseResponse(
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonFunction(json['data']) : null,
      errors: json['errors'],
    );
  }
}

class BaseListResponse<T> {
  final String? message;
  final List<T>? data;
  final String? error;

  BaseListResponse({
    this.message,
    required this.data,
    this.error,
  });

  factory BaseListResponse.fromJson(
    Map<String, dynamic> json,
    Function(Map<String, dynamic>) create,
  ) {
    List<T> data = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(create(v));
      });
    }
    return BaseListResponse<T>(
        message: json['message'] as String?, data: data, error: json['errors']);
  }
}

class BasePagingResponse<T> {
  final List<T>? data;
  final String? error;
  final int? total;
  final int? currentPage;
  final int? perPage;
  final int? lastPage;
  final int? from;
  final int? to;

  BasePagingResponse({
    required this.data,
    this.error,
    this.total,
    this.currentPage,
    this.perPage,
    this.lastPage,
    this.from,
    this.to,
  });

  factory BasePagingResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) create,
  ) {
    final List<T> parsedData = (json['data'] as List<dynamic>?)
            ?.map((e) => create(e as Map<String, dynamic>))
            .toList() ??
        [];

    return BasePagingResponse<T>(
      data: parsedData,
      error: json['errors'] as String?,
      total: json['pagination']?['total'] as int?,
      currentPage: json['pagination']?['current_page'] as int?,
      perPage: json['pagination']?['per_page'] as int?,
      lastPage: json['pagination']?['last_page'] as int?,
      from: json['pagination']?['from'] as int?,
      to: json['pagination']?['to'] as int?,
    );
  }

  // Helper getter for backward compatibility
  int? get pageSize => perPage;
}

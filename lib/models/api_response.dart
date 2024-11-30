/// Class untuk merepresentasikan respons dari API.
/// Menggunakan tipe generik `T` untuk fleksibilitas data.
class ApiResponse<T> {
  /// Data hasil API (jika berhasil).
  T? data;

  /// Pesan error jika terjadi kesalahan.
  String? error;

  /// Status HTTP dari API.
  int? statusCode;

  /// Constructor untuk inisialisasi.
  ApiResponse({this.data, this.error, this.statusCode});

  /// Getter untuk memeriksa apakah respons API berhasil (status HTTP 2xx).
  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;

  /// Getter untuk memberikan pesan error default jika `error` tidak ada.
  String get errorMessage => error ?? 'An unexpected error occurred.';
}

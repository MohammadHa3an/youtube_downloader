import 'dart:io';

/// تابعی برای تمیز کردن نام فایل از کاراکترهای غیرمجاز
String sanitizeFileName(String name) {
  return name.replaceAll(RegExp(r'[\/\\:*?"<>|]'), '_');
}

/// تابعی برای چک کردن و ایجاد پوشه دانلود
Future<String> createDownloadDirectory(String folderName) async {
  // ساخت مسیر برای پوشه دانلود
  var directory = Directory(folderName);

  // چک می‌کند که آیا پوشه وجود دارد یا نه
  if (!await directory.exists()) {
    // اگر وجود نداشت، پوشه را ایجاد می‌کند
    await directory.create(recursive: true);
  }

  return directory.path; // بازگرداندن دایرکتوری ایجاد شده یا موجود
}

/// تابعی برای بررسی وجود یک فایل
Future<bool> fileExists(String filePath) async {
  var file = File(filePath);
  return await file.exists();
}

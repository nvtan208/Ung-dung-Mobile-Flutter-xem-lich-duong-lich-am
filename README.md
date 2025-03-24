# Ứng dụng Mobile Flutter - Xem Lịch Dương Lịch và Âm Lịch 📅

## Giới thiệu 🌟
Đây là một ứng dụng di động được phát triển bằng Flutter, cho phép người dùng tra cứu và xem lịch dương lịch cũng như âm lịch một cách dễ dàng. Ứng dụng mang đến giao diện thân thiện, đơn giản và hiệu quả, phục vụ nhu cầu tra cứu lịch hàng ngày của người Việt Nam.

## Tính năng ✨
- **Xem lịch dương lịch và âm lịch 🗓️**: Hiển thị ngày tháng theo cả hai hệ lịch một cách rõ ràng.
- **Chuyển đổi ngày 🔄**: Chuyển đổi qua lại giữa lịch dương và lịch âm.
- **Giao diện thân thiện 🎨**: Thiết kế đơn giản, dễ sử dụng, phù hợp với mọi đối tượng người dùng.
- **Hỗ trợ đa nền tảng 📱**: Chạy được trên cả Android và iOS nhờ Flutter.

## Yêu cầu cài đặt ⚙️
- Flutter SDK (phiên bản 3.x.x trở lên)
- Dart (đi kèm với Flutter)
- Thiết bị mô phỏng (Android Emulator/iOS Simulator) hoặc thiết bị thật để kiểm tra.

## Hướng dẫn cài đặt 🚀
### Sao chép dự án:
```bash
git clone https://github.com/nvtan208/Ung-dung-Mobile-Flutter-xem-lich-duong-lich-am.git
cd Ung-dung-Mobile-Flutter-xem-lich-duong-lich-am
```

### Cài đặt dependencies:
```bash
flutter pub get
```

### Cấu hình API Key (main.dart):
```bash
apiKey: "",
```

### Chạy ứng dụng:
1. Đảm bảo thiết bị mô phỏng hoặc thiết bị thật đã được kết nối.
2. Chạy lệnh:
```bash
flutter run
```

## Cấu trúc dự án 📂
```
/lib          -> Chứa mã nguồn chính của ứng dụng.
/screens      -> Các màn hình chính (ví dụ: lịch tháng, lịch ngày).
/utils        -> Các hàm tiện ích (ví dụ: chuyển đổi ngày).
/assets       -> Tài nguyên tĩnh như hình ảnh, font chữ (nếu có).
pubspec.yaml  -> Quản lý dependencies và cấu hình ứng dụng.
```

## Công nghệ sử dụng 🛠️
- **Flutter**: Framework chính để xây dựng giao diện và logic ứng dụng.
- **Dart**: Ngôn ngữ lập trình chính.

## Đóng góp 🤝
Mọi đóng góp đều được hoan nghênh! Vui lòng làm theo các bước sau:
1. Fork dự án.
2. Tạo một branch mới:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit thay đổi của bạn:
   ```bash
   git commit -m "Mô tả thay đổi"
   ```
4. Push lên branch của bạn:
   ```bash
   git push origin feature/your-feature
   ```
5. Tạo Pull Request.

## Tác giả 👨‍💻
**nvtan208** - Nhà phát triển chính.


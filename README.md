# Hệ Thống Quản Lý Bãi Đỗ Xe (Frontend Phù hợp cho cả Web-Android-iOS)

## Tổng Quan
Một ứng dụng Flutter hiện đại, đáp ứng (responsive) được thiết kế để quản lý hệ thống bãi đỗ xe thông minh. Ứng dụng này cung cấp giao diện thân thiện cho quản trị viên để giám sát trạng thái bãi đỗ xe theo thời gian thực, quản lý cư dân và phương tiện, cũng như xem nhật ký ra vào chi tiết.

## Tính Năng

### 🖥️ Bảng Điều Khiển (Dashboard)
- **Thống kê thời gian thực**: Xem tổng số cư dân, phương tiện, phiên đỗ xe đang hoạt động và số lượt ra/vào trong ngày.
- **Biểu đồ tương tác**: Phân tích trực quan lưu lượng giao thông hàng ngày (Vào vs Ra).
- **Nguồn cấp dữ liệu trực tiếp (Live Feed)**: Cập nhật thời gian thực các phương tiện ra vào khu vực.

### 👥 Quản Lý
- **Cư dân**: Thêm, sửa và xóa thông tin cư dân.
- **Phương tiện**: Đăng ký phương tiện và liên kết với cư dân. Hỗ trợ nhiều loại phương tiện (Ô tô, Xe máy).

### 📊 Giám Sát
- **Lịch sử đỗ xe**: Lịch sử chi tiết các phiên đỗ xe đã hoàn tất với thời gian và hình ảnh.
- **Nhật ký ra vào**: Nhật ký toàn diện về tất cả các lần truy cập, bao gồm cả các lần vào được ủy quyền và không được ủy quyền, kèm theo dấu thời gian và hình ảnh chụp được.

### 🎨 Giao Diện (UI/UX)
- **Thiết kế Responsive**: Trải nghiệm liền mạch trên Web Desktop (>900px) và thiết bị Di động.
  - **Web**: Thanh điều hướng bên (Sidebar) cố định và bảng dữ liệu mở rộng.
  - **Mobile**: Điều hướng ngăn kéo (Drawer) và chế độ xem thẻ/danh sách tối ưu hóa.
- **Giao diện hiện đại**: Bảng màu sống động, gradient và thẩm mỹ bo tròn.

## Công Nghệ Sử Dụng
- **Framework**: [Flutter](https://flutter.dev/)
- **Quản lý trạng thái**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Kết nối mạng**: 
  - [dio](https://pub.dev/packages/dio) (HTTP Requests)
  - [socket_io_client](https://pub.dev/packages/socket_io_client) (WebSockets thời gian thực)
- **Thành phần UI**:
  - [fl_chart](https://pub.dev/packages/fl_chart) (Biểu đồ)
  - [data_table_2](https://pub.dev/packages/data_table_2) (Bảng dữ liệu nâng cao)
  - [google_fonts](https://pub.dev/packages/google_fonts) (Phông chữ)

## Bắt Đầu

### Yêu Cầu Tiên Quyết
- Flutter SDK (Bản ổn định mới nhất)
- Dart SDK

### Cài Đặt

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd fe_car_parking
   ```

2. **Cài đặt các gói phụ thuộc**
   ```bash
   flutter pub get
   ```

### Chạy Ứng Dụng

#### 🌐 Web (Khuyên dùng cho Phát triển)
Để tránh lỗi CORS (Cross-Origin Resource Sharing) khi kết nối với backend cục bộ, hãy chạy Chrome với cờ tắt bảo mật web:

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

#### 📱 Android Emulator
Nếu bạn thích chạy trên Android Emulator:

1. **Cấu hình Base URL**: 
   Mở `lib/core/constants.dart` và đảm bảo `baseUrl` được đặt thành địa chỉ loopback của Android emulator:
   ```dart
   static const String baseUrl = 'http://10.0.2.2:3000';
   ```

2. **Chạy ứng dụng**:
   ```bash
   flutter run
   ```

## Cấu Trúc Dự Án

```
lib/
├── blocs/           # Business Logic Components (Quản lý trạng thái)
├── core/            # Cấu hình cốt lõi (API, Theme, Constants)
├── models/          # Mô hình dữ liệu (Data Models)
├── screens/         # Màn hình UI (Dashboard, Residents, v.v.)
├── widgets/         # Các Widget UI tái sử dụng
└── main.dart        # Điểm khởi chạy ứng dụng
```



# TRAVELWITH3CE: ỨNG DỤNG ĐẶT PHÒNG DU LỊCH

Travelwith3CE là một ứng dụng đặt phòng du lịch full-stack, được phát triển với **Flutter** cho phần frontend, **Dart** và **Firebase** cho phần backend. Ứng dụng hỗ trợ người dùng tìm kiếm, đặt phòng khách sạn, quản lý thông tin cá nhân và cung cấp bảng điều khiển cho quản trị viên để quản lý khách sạn, đặt phòng, cũng như phản hồi của người dùng.

## Các chức năng chính

### 1. Người dùng

- Đăng ký tài khoản, đăng nhập, và cập nhật hồ sơ cá nhân.
- Xem danh sách các phòng đã đặt và trạng thái đặt phòng.
- Tìm kiếm và đặt phòng.
- Xem chi tiết các phòng.
- Đổi mật khẩu.

### 2. Bảng điều khiển cho quản trị viên

#### Quản lý khách sạn:

- Thêm, sửa, và xóa thông tin khách sạn, bao gồm hình ảnh, giá cả, và tiện nghi.
- Xem danh sách đặt phòng và thay đổi trạng thái (đã xác nhận, đang xử lý, đã hủy).
- Đăng nhập.

#### Quản trị viên ứng dụng:

- Quản lý người dùng.
- Quản lý phòng.
- Quản lý tài khoản khách sạn.
- Tạo tài khoản khách sạn.

---

## Công nghệ sử dụng

- **Flutter**: Framework chính để xây dựng giao diện người dùng.
- **Dart**: Ngôn ngữ lập trình chính hỗ trợ Flutter, tập trung vào hiệu suất khi xây dựng giao diện và xử lý logic.
- **Firebase**: Dùng để quản lý dữ liệu, xác thực người dùng và các chức năng backend như đồng bộ hóa dữ liệu thời gian thực.

---

## Hướng dẫn cài đặt

### 1. Yêu cầu môi trường

- **Flutter SDK**:
  - Tải và cài đặt từ [Flutter Docs](https://docs.flutter.dev/get-started/install).
  - Kiểm tra cài đặt:
    ```bash
    flutter --version
    ```
- **IDE**:
  - Sử dụng **Android Studio** hoặc **Visual Studio Code** với các plugin hỗ trợ Flutter.
- **Firebase CLI**:
  - Cài đặt bằng lệnh:
    ```bash
    npm install -g firebase-tools
    ```

### 2. Cài đặt và Chạy Ứng dụng

- **Clone mã nguồn**:
  ```bash
  git clone https://github.com/utthi103/3CETravel.git
  cd 3CETravel
  ```

### Cấu hình Firebase

1. **Tạo dự án trên Firebase Console**:

   - Truy cập [Firebase Console](https://console.firebase.google.com/), đăng nhập bằng tài khoản Google của bạn và tạo một dự án mới hoặc chọn một dự án hiện có.

2. **Cấu hình Firebase cho ứng dụng Android**:

   - Vào **Project Settings** trong Firebase Console, chọn **Add App** và chọn biểu tượng **Android**.
   - Điền thông tin ứng dụng của bạn và tải tệp cấu hình `google-services.json`.
   - Thêm tệp `google-services.json` vào thư mục `android/app` trong dự án Flutter của bạn.

3. **Cấu hình Firebase cho ứng dụng iOS**:

   - Vào **Project Settings** trong Firebase Console, chọn **Add App** và chọn biểu tượng **iOS**.
   - Điền thông tin ứng dụng của bạn và tải tệp cấu hình `GoogleService-Info.plist`.
   - Thêm tệp `GoogleService-Info.plist` vào thư mục `ios/Runner` trong dự án Flutter của bạn.

4. **Cấu hình Firebase cho ứng dụng Web**:

   - Truy cập **Project Settings** trong Firebase Console, chọn **Add App** và chọn biểu tượng **Web**.
   - Firebase sẽ cung cấp một đoạn mã cấu hình chứa các thông tin như `apiKey`, `authDomain`, `projectId`, v.v.
   - Sao chép đoạn mã cấu hình này và dán vào tệp cấu hình của ứng dụng web trong mã nguồn của bạn (ví dụ: `firebase-config.js`).
   - Đoạn mã mẫu:

     ```javascript
     const firebaseConfig = {
       apiKey: "YOUR_API_KEY",
       authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
       projectId: "YOUR_PROJECT_ID",
       storageBucket: "YOUR_PROJECT_ID.appspot.com",
       messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
       appId: "YOUR_APP_ID",
     };

     // Initialize Firebase
     import { initializeApp } from "firebase/app";
     const app = initializeApp(firebaseConfig);
     ```

5. **Cài đặt Firebase SDK**:
   - Cài đặt Firebase SDK bằng npm:
     ```bash
     npm install firebase
     ```

### Cài đặt phụ thuộc

- Chạy lệnh sau để cài đặt các phụ thuộc trong dự án:
  ```bash
  flutter pub get
  ```

### Chạy ứng dụng

1. **Kết nối thiết bị hoặc mở mô phỏng**:

   - Để kiểm tra các thiết bị được kết nối hoặc các mô phỏng (emulators) đang hoạt động, bạn có thể chạy lệnh:
     ```bash
     flutter devices
     ```
     Lệnh này sẽ liệt kê tất cả các thiết bị Android/iOS đang kết nối hoặc các mô phỏng mà bạn có thể chạy ứng dụng.

2. **Chạy ứng dụng**:
   - Để chạy ứng dụng trên thiết bị hoặc mô phỏng đã chọn, sử dụng lệnh:
     ```bash
     flutter run
     ```
     Flutter sẽ biên dịch ứng dụng và triển khai lên thiết bị hoặc mô phỏng. Quá trình này sẽ tự động bắt đầu và ứng dụng của bạn sẽ chạy trực tiếp trên thiết bị/mô phỏng.

## Link video Demo:

[Video Demo](https://drive.google.com/file/d/1M1hL4LI0GDCAewokshe9lZDgfqDBly5Z/view?usp=sharing)

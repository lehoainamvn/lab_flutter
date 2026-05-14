# Flutter Shopping Cart App với MongoDB

Ứng dụng shopping cart được xây dựng bằng Flutter với state management sử dụng Provider package và backend Node.js kết nối MongoDB.

## Tính năng

- 🔐 Màn hình đăng nhập đơn giản
- 📱 Giao diện catalog hiển thị danh sách sản phẩm
- 🛒 Giỏ hàng với khả năng thêm/xóa sản phẩm
- 💰 Tính tổng giá trị đơn hàng
- 🔄 State management với Provider
- 🗄️ Kết nối MongoDB để lưu trữ dữ liệu

## Cấu trúc project

```
├── lib/
│   ├── models/          # Data models (Item, CartModel, CatalogModel)
│   ├── screens/         # UI screens (Login, Catalog, Cart)
│   ├── widgets/         # Reusable widgets
│   ├── services/        # API services
│   └── main.dart        # Entry point
├── backend/
│   ├── models/          # MongoDB models
│   ├── routes/          # API routes
│   ├── server.js        # Express server
│   └── .env             # Environment variables
└── README.md
```

## Cài đặt và chạy

### 1. Backend (Node.js + MongoDB)

```bash
cd backend
npm install
npm start
```

Server sẽ chạy tại: http://localhost:3000

### 2. Flutter App

```bash
flutter pub get
flutter run
```

## API Endpoints

- `GET /api/items` - Lấy danh sách sản phẩm
- `GET /api/cart` - Lấy items trong giỏ hàng
- `POST /api/cart` - Thêm item vào giỏ hàng
- `DELETE /api/cart/:itemId` - Xóa item khỏi giỏ hàng
- `DELETE /api/cart` - Xóa tất cả items trong giỏ hàng

## MongoDB Configuration

Thông tin kết nối MongoDB được cấu hình trong file `backend/.env`:

```
MONGODB_USERNAME=2224802010139_db_user
MONGODB_PASSWORD=IxWoQM7io310Muy7
MONGODB_URI=mongodb+srv://2224802010139_db_user:IxWoQM7io310Muy7@lab5todu.rq2xss9.mongodb.net/ToDoDB?retryWrites=true&w=majority&appName=lab5todu
PORT=3000
```

## State Management với Provider

Ứng dụng sử dụng Provider pattern để quản lý state:

### CartModel
- Quản lý danh sách items trong giỏ hàng
- Tính tổng giá trị đơn hàng
- Thêm/xóa items
- Thông báo UI khi state thay đổi

### CatalogModel
- Quản lý danh sách sản phẩm
- Cung cấp methods để truy xuất sản phẩm

## Giao diện

1. **Login Screen**: Màn hình đăng nhập với username/password
2. **Catalog Screen**: Hiển thị danh sách sản phẩm với nút ADD
3. **Cart Screen**: Hiển thị items đã chọn và tổng giá trị

## Dependencies

### Flutter
- `provider: ^6.1.1` - State management
- `http: ^1.1.0` - HTTP requests

### Backend
- `express: ^4.18.2` - Web framework
- `mongoose: ^8.0.0` - MongoDB ODM
- `cors: ^2.8.5` - CORS middleware
- `dotenv: ^16.3.1` - Environment variables

## Chạy trong development

1. Khởi động MongoDB server
2. Chạy backend: `cd backend && npm run dev`
3. Chạy Flutter app: `flutter run`

Ứng dụng sẽ tự động kết nối với MongoDB và khởi tạo dữ liệu mẫu nếu database trống.
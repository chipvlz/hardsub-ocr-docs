# hardsub-ocr-docs

Tài liệu triển khai và vận hành hệ thống OCR cho phụ đề hardsub.

## 1. Kiến trúc

Hệ thống sử dụng mô hình microservice gồm:

- **FastAPI**: Cung cấp REST API và giao diện web để người dùng gửi video, theo dõi trạng thái và tải về tệp SRT.
- **Celery**: Thực thi các tác vụ OCR nặng trong nền, cho phép xử lý song song và phân tán.
- **Redis**: Làm broker cho Celery và cache lưu trạng thái tác vụ.

Luồng xử lý: FastAPI nhận yêu cầu → tạo tác vụ Celery → worker Celery đọc hàng đợi từ Redis → lưu kết quả → FastAPI phản hồi trạng thái cho người dùng.

## 2. Cấu hình Google Drive, API key/JWT, biến môi trường

1. Vào Google Cloud Console, tạo dự án và bật Google Drive API.
2. Tạo Service Account, cấp quyền truy cập thư mục chứa video, tải file JSON.
3. Đặt biến môi trường, ví dụ:

```
GOOGLE_APPLICATION_CREDENTIALS=/app/credentials.json
GOOGLE_DRIVE_FOLDER_ID=abc123
API_KEY=<api-key-danh-cho-client>
JWT_SECRET=<chuoi-bi-mat>
REDIS_URL=redis://redis:6379/0
```

4. Lưu các biến vào tệp `.env` và đảm bảo Docker Compose đọc tệp này.

## 3. Build & chạy với Docker Compose

```
docker compose build
docker compose --env-file .env up -d
```

- `web`: chạy FastAPI tại `http://localhost:8000`.
- `worker`: chạy Celery và kết nối tới Redis.

## 4. Sử dụng trang web

1. Truy cập `http://localhost:8000`.
2. Chọn video hoặc dán ID Google Drive.
3. Gửi yêu cầu và theo dõi trang trạng thái.
4. Khi hoàn tất, tải tệp SRT tại cùng trang.

## 5. Dọn dẹp, log và mở rộng

- Dừng hệ thống: `docker compose down`.
- Xóa cả volume/cache: `docker compose down -v`.
- Xem log: `docker compose logs -f web` hoặc `docker compose logs -f worker`.
- Mở rộng: thêm worker Celery, hỗ trợ ngôn ngữ OCR mới, thay đổi backend lưu trữ.

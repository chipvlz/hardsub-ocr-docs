FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir celery
EXPOSE 7415
CMD ["python", "-m", "http.server", "7415"]

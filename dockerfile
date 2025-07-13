FROM python:3.11-alpine

RUN adduser -D -s /bin/sh appuser

WORKDIR /app

COPY app.py .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8005

CMD ["python", "app.py"]
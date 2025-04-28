FROM python:3.11-slim

WORKDIR /app
COPY app.py /app/
COPY templates /app/templates/

RUN pip install Flask

ENV VERSION=v1

CMD ["python", "app.py"]
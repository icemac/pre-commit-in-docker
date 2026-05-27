FROM python:3.13-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir pre-commit==4.6.0

WORKDIR /src

ENTRYPOINT ["pre-commit"]
CMD ["run", "--all-files"]

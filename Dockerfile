FROM python:3.13-slim

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends git libatomic1 && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir pre-commit==4.6.0 pre-commit-uv==4.2.1 uv==0.11.16

WORKDIR /src

ENTRYPOINT ["pre-commit"]
CMD ["run", "--all-files"]

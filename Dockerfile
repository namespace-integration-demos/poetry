FROM python:3.11-buster as builder

RUN pip install poetry==1.4.2

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /app

# Only copy pyproject.toml and poetry.lock to not invalidate build cache when the code changes.
COPY pyproject.toml poetry.lock /app/

# Poetry requires a README.md file. But we don't want changes to the README to invalidate our build cache.
RUN touch README.md

# Retain Poetry dependency cache in a cache mount.
# This ensures that we keep cached deps even if our deps change.
RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --without dev --no-root

FROM python:3.11-slim-buster as runtime

WORKDIR /app 
ENV VIRTUAL_ENV=/app/.venv

# Only copy venv from the builder to keep the final image size small.
COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY . /app

RUN useradd -u 1000 djangouser
RUN chown -R djangouser /app
USER djangouser

EXPOSE 8000
ENTRYPOINT ["python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]

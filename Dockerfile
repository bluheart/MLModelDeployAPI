FROM python:3.11

LABEL authors="bluheart"

RUN apt-get update && apt-get install -y curl build-essential

ADD https://astral.sh/uv/install.sh /tmp/install_uv.sh

RUN bash /tmp/install_uv.sh && rm /tmp/install_uv.sh

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin/:$PATH"

WORKDIR /code

COPY pyproject.toml uv.lock /code/

# Install dependencies using UV based on your lock file
RUN uv sync --locked --all-extras --no-dev

ENV PATH="/code/.venv/bin:$PATH"

COPY ./app /code/app

EXPOSE 8000

CMD ["uvicorn", "app.server:app", "--host", "0.0.0.0", "--port", "8000"]
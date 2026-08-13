FROM node:20-slim

# Install system dependencies
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install Cursor CLI (provides the `agent` command)
RUN curl https://cursor.com/install -fsS | bash && \
    ln -sf /root/.local/bin/agent /usr/local/bin/agent && \
    ln -sf /root/.local/bin/cursor-agent /usr/local/bin/cursor-agent

# Set up app directory
WORKDIR /app
COPY . .

# Install dependencies and build
RUN npm install -g pnpm && pnpm install && pnpm build

# Link the local package to make cursor-agent-api command available
RUN npm link

ENV PORT=4646

EXPOSE 4646

CMD ["cursor-agent-api", "run"]

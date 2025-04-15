FROM node:18-slim

# Install Python and uv
RUN apt-get update && apt-get install -y python3 python3-venv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set up working directory
WORKDIR /app

# Copy package.json and install npm dependencies
COPY package.json .
RUN npm install

# Copy Python project files
COPY . .

# Set up Python environment and install dependencies
RUN python3 -m venv .venv
RUN . .venv/bin/activate && uv sync

# Expose the port the app runs on
EXPOSE 8001

# Command to run the application
CMD [".venv/bin/python", "src/atla-mcp-server.py"]
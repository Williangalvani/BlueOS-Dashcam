FROM bluerobotics/blueos-base:latest

# Set working directory
WORKDIR /app

# Create necessary directories
RUN mkdir -p static views

# Download Vue.js into static directory (using a specific version to ensure stability)
RUN curl -s https://unpkg.com/vue@3.3.4/dist/vue.global.prod.js -o static/vue.js

RUN apt update && apt install -y gcc
RUN python -m pip install websockets aiohttp

# Copy the rest of the application
COPY . .

# Set default environment variables
ENV LOG_FOLDER=/home/blueos/logs
ENV VIDEO_FOLDER=/home/blueos/videos
ENV SETTINGS_FOLDER=/home/blueos/settings
ENV MAVLINK_URL=ws://blueos.internal/mavlink2rest/ws/mavlink?filter=HEARTBEAT
ENV PYTHONUNBUFFERED=1

# Create necessary directories for storage
RUN mkdir -p $LOG_FOLDER $VIDEO_FOLDER

# Expose the web interface port
EXPOSE 8080

# Run the application
CMD ["sh", "-c", "python video_recorder.py --log-folder $LOG_FOLDER --video-folder $VIDEO_FOLDER --mavlink-url $MAVLINK_URL"] 
# Use the official Rust image as the base image
FROM rust:1.70 as builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the source code to the container
COPY main.rs Cargo.toml Cargo.lock .

# Build the Rust project
RUN cargo build --release

# Use a minimal base image to run the application (Debian-based image)
FROM debian:bullseye

# Install dependencies required by the Rust binary (optional, only if needed)
RUN apt-get update && apt-get install -y libssl1.1 ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/app/target/release/server /usr/local/bin/server

# Expose the port that the server will listen on
EXPOSE 3000

# Set the default command to run your application
CMD ["server"]


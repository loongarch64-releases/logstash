# Logstash (LoongArch64 Build)

[![Build Status](https://github.com/loongarch64-releases/logstash/actions/workflows/release.yml/badge.svg)](https://github.com/loongarch64-releases/logstash/actions)

This repository contains the LoongArch64 build configuration and scripts for **[logstash](https://github.com/elastic/logstash)**, originally developed by **elastic**.

## Quick Start

### Prerequisites
- A LoongArch64 environment (native or QEMU user emulation).
- Docker (optional, for containerized builds).

### Build from Source

1. **Clone this repository**:
   ```bash
   git clone https://github.com/loongarch64-releases/logstash.git
   cd logstash
   ```

2. **Get latest version**
   ```bash
   ./scripts/get_version.sh
   <version>
   ```

3. **Run the build script**:
   ```bash
   ./scripts/build.sh <version>
   ```
   *Or build inside a Docker container:*
   ```bash
   ./scripts/build_in_docker.sh <version>
   ```

4. **Get the binary**:
   The compiled binaries will be available in the `dists/<version>` directory.

## Development

- **Source Code**: The original source is managed upstream at [elastic/logstash](https://github.com/elastic/logstash).
- **Patches**: Any LoongArch-specific patches are stored in the `patches/` directory (if applicable).
- **CI/CD**: Automated builds are handled via GitHub Actions (see `.github/workflows/`).

## License

This build wrapper inherits the license of the original project: **elastic/logstash**.

Please refer to the upstream repository for the full license text.

---
*Generated automatically from release-tools.*

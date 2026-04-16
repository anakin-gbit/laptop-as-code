# laptop-as-code

**A modular, automated provisioning system for an ephemeral Linux workstation.**

## Overview
This repository contains the "Public Blueprint" for my portable desktop environment. Moving away from the bloat and privacy concerns of traditional consumer operating systems, this project applies **Infrastructure as Code (IaC)** principles to a personal workstation.

The OS lives on a high-speed USB stick, treating the underlying hardware as a generic host. This ensures that my environment is portable, disposable, and 100% reproducible.

## The Philosophy
* **Zero Bloat:** Built from a base `Ubuntu Server` image. Only the necessary Desktop Environment (DE) and tools are installed.
* **Immutable Workflow:** Configuration changes are made in code first. The running system is a reflection of this repository.
* **Zero-Trust Security:** Private identities (SSH keys, GPG, AWS credentials) are decoupled from this public repo and injected post-boot via a secure SSO-authorized handshake.

## Architecture
The build is split into two distinct phases:

1.  **Phase 1 (Public):** Triggered by `cloud-init` on boot. It pulls the scripts in this repo to establish the GUI, hardware drivers, and core privacy hardening.
2.  **Phase 2 (Private):** Occurs after manual OIDC/SSO authentication. It pulls encrypted configuration and identity secrets from a private S3 bucket.

## Quick Start
To bootstrap a new instance:
1. Flash a USB with Ubuntu Server LTS.
2. Add the `user-data` (Cloud-Init) file pointing to the `bootstrap.sh` in this repo.
3. Boot and watch the logs.

## Current Build Status
- [x] Hello World Bootstrap
- [ ] Core GUI (TBD)
- [ ] Laptop QoL & Power Mgmt
- [ ] SSO Identity Integration
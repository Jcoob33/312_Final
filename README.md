## Requirements For Pipeline

### Needed Tools

- **Terraform** (v1.0+)
  - Installation:
    - **Windows**: Download from [Terraform Downloads](https://www.terraform.io/downloads.html).
    - **macOS**: Use Homebrew: `brew tap hashicorp/tap && brew install hashicorp/tap/terraform`.
    - **Linux**: Use the package manager or download from [Terraform Downloads](https://www.terraform.io/downloads.html).

- **Ansible** (v2.9+)
  - Installation:
    - **Windows**: Use WSL and follow Linux instructions.
    - **macOS**: Use Homebrew: `brew install ansible`.
    - **Linux**: Use the package manager: `sudo apt update && sudo apt install ansible`.

- **AWS CLI** (v2)
  - Installation:
    - **Windows**: Download from [AWS CLI Installer](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
    - **macOS**: Use Homebrew: `brew install awscli`.
    - **Linux**: Use the package manager: `sudo apt install awscli`.
  - Configure: `aws configure`.

- **SSH Client**
  - Installation:
    - **Windows**: Use the built-in OpenSSH client or install [PuTTY](https://www.putty.org/).
    - **macOS and Linux**: SSH client is usually pre-installed.

- **Docker**
  - Installation:
    - **Windows and macOS**: Download and install from [Docker Desktop](https://www.docker.com/products/docker-desktop).
    - **Linux**: Use the package manager: `sudo apt update && sudo apt install docker.io`.

### Configuration

- **AWS Credentials**: Configure your AWS CLI with valid credentials using `aws configure`.
- **Ensure SSH Key Permissions**: Set the correct permissions for the SSH private key: `chmod 400 terraform/minecraft-key.pem`.

## Diagram of the Major Steps in the Pipeline

```mermaid
graph TD;
    A[User Setup] --> B[Terraform Apply]
    B --> C[Provision AWS Resources]
    C --> D[Run Ansible Playbook]
    D --> E[Configure and Start Minecraft Server]
    E --> F[Access Minecraft Server]

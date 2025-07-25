# Red Hat Satellite 6.17 Integrated Deployment System

This repository contains a comprehensive, integrated deployment system for Red Hat Satellite 6.17 that combines all functionality into a single Ansible playbook with multiple operational modes.

## Overview

The system has been completely integrated into `satellite_setup_playbook.yml` which now includes:
- ✅ Interactive host selection (local or remote deployment)
- ✅ Complete deployment automation
- ✅ Preflight checks and validation
- ✅ Undo/rollback functionality  
- ✅ Management script creation
- ✅ Comprehensive error handling and reporting

## Quick Start

### Method 1: Simple Launcher (Recommended)
```bash
./satellite-deploy.sh
```

This provides an interactive menu with all available options.

### Method 2: Direct Ansible Execution

#### Interactive Deployment with Host Selection
```bash
ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e "interactive_mode=true"
```

#### Undo Previous Deployment
```bash
ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e "undo_deployment=true"
```

#### Preflight Checks Only
```bash
ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e "deployment_mode=preflight"
```

## Available Deployment Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| `preflight` | Run only preflight checks | Validate system before deployment |
| `full` | Complete Satellite deployment | Production deployment |
| `quick` | Minimal deployment for testing | Development/testing environments |

## Available Variables

| Variable | Values | Default | Description |
|----------|--------|---------|-------------|
| `interactive_mode` | true/false | false | Enable interactive prompts and host selection |
| `deployment_mode` | preflight/full/quick | full | Deployment operation mode |
| `undo_deployment` | true/false | false | Undo previous deployment changes |
| `force_deployment` | true/false | false | Force deployment despite warnings |
| `skip_preflight` | true/false | false | Skip preflight checks (not recommended) |
| `skip_registration` | true/false | false | Skip Red Hat subscription registration |

## Usage Examples

### 1. First-Time Interactive Deployment
```bash
# Recommended for new users - includes host selection and all prompts
./satellite-deploy.sh
# Select option 1 for interactive deployment
```

### 2. Direct Interactive Deployment
```bash
ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
    -e "interactive_mode=true" \
    -e "deployment_mode=full"
```

### 3. Automated Deployment (No Prompts)
```bash
ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
    -e "deployment_mode=full" \
    -e "force_deployment=true"
```

### 4. Undo Previous Deployment
```bash
ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
    -e "undo_deployment=true" \
    -e "interactive_mode=true"
```

### 5. Remote Deployment (Interactive Host Selection)
```bash
# The playbook will prompt for remote host details
ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
    -e "interactive_mode=true"
# Choose option 2 for remote deployment when prompted
```

### 6. Health Check / Preflight Only
```bash
ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
    -e "deployment_mode=preflight"
```

### 7. Verbose Deployment with Debug Information
```bash
ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
    -e "interactive_mode=true" \
    -vvv
```

## Integrated Features

### 🎯 Host Selection
- Interactive prompts for local vs remote deployment
- Automatic connectivity testing for remote hosts
- Dynamic inventory management
- SSH credential collection and validation

### 🔍 Preflight Checks
- System requirements validation (RAM, CPU, disk space, architecture)
- Network connectivity testing
- Red Hat subscription status verification
- Repository access validation
- Ansible collection dependency checks

### 🚀 Deployment Automation
- Complete Satellite 6.17 installation
- Network service configuration (DHCP, DNS, TFTP)
- Firewall and SELinux configuration
- SSL certificate setup
- Post-installation validation

### � Undo Functionality
- Complete rollback of deployment changes
- Hostname restoration
- User account cleanup
- Package removal (optional)
- Service state restoration
- Configuration file cleanup

### 🛠️ Management Scripts
After deployment, the following management scripts are automatically created:

| Script | Purpose |
|--------|---------|
| `satellite-deploy` | Main deployment interface (created during deployment) |
| `satellite-maintenance` | Maintenance mode operations |
| `satellite-monitor` | Health monitoring and checks |
| `satellite-backup` | Backup and restore operations |

## System Requirements

- **Operating System**: RHEL 9.x
- **RAM**: Minimum 20GB (recommended 32GB)
- **CPU**: Minimum 4 cores (recommended 8 cores)
- **Disk Space**: Minimum 120GB (recommended 500GB)
- **Architecture**: x86_64
- **Network**: Internet connectivity for Red Hat CDN access

## Prerequisites

1. **Ansible Installation**:
   ```bash
   sudo dnf install -y ansible-core
   ansible-galaxy collection install ansible.posix community.general
   ```

2. **Red Hat Subscription**: Valid Red Hat customer portal credentials

3. **SSH Access**: For remote deployments, ensure SSH key-based authentication is configured

## File Structure

```
satellite-deployment/
├── satellite_setup_playbook.yml    # Main integrated playbook
├── satellite-deploy.sh              # Simple launcher script
├── inventory.ini                    # Ansible inventory
├── ansible.cfg                      # Ansible configuration
├── requirements.yml                 # Ansible requirements
├── vars/                           # Variable definitions
│   └── satellite_vars.yml
├── templates/                      # Template files
│   └── vault.yml
└── README.md                       # This file
```

## Troubleshooting

### Common Issues and Solutions

1. **Subscription Manager Timeout**
   ```bash
   # Use bypass mode
   ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
       -e "skip_registration=true"
   ```

2. **Insufficient System Resources**
   ```bash
   # Run preflight checks to identify specific issues
   ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
       -e "deployment_mode=preflight"
   ```

3. **Failed Deployment Cleanup**
   ```bash
   # Use integrated undo functionality
   ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
       -e "undo_deployment=true"
   ```

4. **Network Connectivity Issues**
   ```bash
   # Test with verbose output
   ansible-playbook -i inventory.ini satellite_setup_playbook.yml \
       -e "deployment_mode=preflight" -vvv
   ```

### Log Locations

- **Deployment Report**: `/var/log/satellite_deployment_report.log`
- **Preflight Failures**: `/tmp/satellite_preflight_failure_report.txt`
- **Ansible Logs**: Use `-vvv` flag for detailed output

## Security Considerations

- Credentials can be stored in encrypted Ansible vault files
- SSH keys are generated for system administration
- Firewall rules are automatically configured
- SELinux booleans are properly set for Satellite operations

## Integration Benefits

✅ **Unified Interface**: Single playbook handles all operations
✅ **Reduced Complexity**: No external script dependencies  
✅ **Better Error Handling**: Comprehensive validation and reporting
✅ **Consistent Experience**: Same interface for all operations
✅ **Easier Maintenance**: Single codebase to maintain and update
✅ **Enhanced Security**: Integrated credential management
✅ **Comprehensive Logging**: Detailed operation tracking
✅ **Rollback Capability**: Built-in undo functionality

## Support

For issues and questions:
1. Check the preflight report: `ansible-playbook -i inventory.ini satellite_setup_playbook.yml -e "deployment_mode=preflight"`
2. Review deployment logs with verbose output: `-vvv`
3. Use the undo functionality if needed: `-e "undo_deployment=true"`
4. Consult Red Hat Satellite documentation for product-specific issues

---
**Note**: This integrated system replaces all previous external scripts with a unified Ansible-based approach for better maintainability and consistency.
| `satellite_hostname` | Text | `satellite` | Yes | Satellite server hostname |
| `satellite_fqdn` | Text | `satellite.example.com` | Yes | Fully Qualified Domain Name |
| `satellite_ip` | Text | `{{ ansible_default_ipv4.address }}` | Yes | Satellite server IP address |
| `satellite_organization` | Text | `Default Organization` | Yes | Satellite organization name |
| `satellite_location` | Text | `Default Location` | Yes | Satellite location name |
| `satellite_admin_username` | Text | `admin` | Yes | Satellite admin username |

### 🔐 **Credential Variables** (Use Survey Password Fields)

| Variable Name | Type | Default Value | Required | Description |
|---------------|------|---------------|----------|-------------|
| `satellite_admin_password` | Password | - | Yes | Satellite admin password |
| `redhat_username` | Text | - | Yes | Red Hat Customer Portal username |
| `redhat_password` | Password | - | Yes | Red Hat Customer Portal password |

### 🌐 **Network Configuration Variables**

| Variable Name | Type | Default Value | Required | Description |
|---------------|------|---------------|----------|-------------|
| `dhcp_interface` | Text | `{{ ansible_default_ipv4.interface }}` | Yes | Network interface for DHCP |
| `dhcp_gateway` | Text | - | Yes | DHCP gateway IP (e.g., 192.168.1.1) |
| `dhcp_range` | Text | - | Yes | DHCP IP range (e.g., 192.168.1.100 192.168.1.200) |
| `dns_interface` | Text | `{{ ansible_default_ipv4.interface }}` | Yes | Network interface for DNS |
| `dns_reverse_zone` | Text | - | Yes | DNS reverse zone (e.g., 1.168.192.in-addr.arpa) |

### 💾 **Backup Configuration Variables**

| Variable Name | Type | Default Value | Required | Description |
|---------------|------|---------------|----------|-------------|
| `satellite_backup_dir` | Text | `/var/satellite-backups` | No | Backup directory path |
| `satellite_backup_retention_days` | Integer | `30` | No | Backup retention in days |

### 🔒 **Security Variables**

| Variable Name | Type | Default Value | Required | Description |
|---------------|------|---------------|----------|-------------|
| `store_credentials_in_vault` | Boolean | `false` | No | Store credentials in encrypted vault |
| `vault_file_path` | Text | `{{ ansible_env.HOME }}/.ansible/satellite_vault.yml` | No | Vault file location |

### 📁 **Remote Deployment Variables**

| Variable Name | Type | Default Value | Required | Description |
|---------------|------|---------------|----------|-------------|
| `remote_deployment_dir` | Text | `/opt/satellite-deployment` | No | Remote script deployment directory |

## Survey Configuration Examples

### Basic Survey (Minimal Variables)
For a simple deployment, include these essential variables in your survey:

```yaml
survey_spec:
  - question_name: "Satellite FQDN"
    question_description: "Enter the Fully Qualified Domain Name for Satellite"
    required: true
    type: "text"
    variable: "satellite_fqdn"
    default: "satellite.example.com"

  - question_name: "Red Hat Username"
    question_description: "Red Hat Customer Portal username"
    required: true
    type: "text"
    variable: "redhat_username"

  - question_name: "Red Hat Password"
    question_description: "Red Hat Customer Portal password"
    required: true
    type: "password"
    variable: "redhat_password"

  - question_name: "Satellite Admin Password"
    question_description: "Password for Satellite admin user"
    required: true
    type: "password"
    variable: "satellite_admin_password"

  - question_name: "DHCP Gateway"
    question_description: "Gateway IP for DHCP configuration"
    required: true
    type: "text"
    variable: "dhcp_gateway"
    default: "192.168.1.1"

  - question_name: "DHCP Range"
    question_description: "IP range for DHCP (e.g., 192.168.1.100 192.168.1.200)"
    required: true
    type: "text"
    variable: "dhcp_range"
    default: "192.168.1.100 192.168.1.200"

  - question_name: "DNS Reverse Zone"
    question_description: "DNS reverse zone (e.g., 1.168.192.in-addr.arpa)"
    required: true
    type: "text"
    variable: "dns_reverse_zone"
    default: "1.168.192.in-addr.arpa"
```

### Advanced Survey (All Options)
For full control, include all variables:

```yaml
survey_spec:
  # Core Deployment
  - question_name: "Deployment Mode"
    question_description: "Select deployment type"
    required: true
    type: "multiplechoice"
    variable: "deployment_mode"
    choices: ["full", "preflight"]
    default: "full"

  - question_name: "Skip Pre-flight Checks"
    question_description: "Skip system validation checks"
    required: false
    type: "multiplechoice"
    variable: "skip_preflight"
    choices: ["true", "false"]
    default: "false"

  - question_name: "Skip Subscription Checks"
    question_description: "Skip subscription and repository validation"
    required: false
    type: "multiplechoice"
    variable: "skip_subscription_check"
    choices: ["true", "false"]
    default: "false"

  # Satellite Configuration
  - question_name: "Satellite Hostname"
    question_description: "Server hostname"
    required: true
    type: "text"
    variable: "satellite_hostname"
    default: "satellite"

  - question_name: "Satellite FQDN"
    question_description: "Fully Qualified Domain Name"
    required: true
    type: "text"
    variable: "satellite_fqdn"

  - question_name: "Satellite IP Address"
    question_description: "Server IP address"
    required: true
    type: "text"
    variable: "satellite_ip"

  - question_name: "Organization Name"
    question_description: "Satellite organization"
    required: true
    type: "text"
    variable: "satellite_organization"
    default: "Default Organization"

  - question_name: "Location Name"
    question_description: "Satellite location"
    required: true
    type: "text"
    variable: "satellite_location"
    default: "Default Location"

  # Credentials
  - question_name: "Red Hat Username"
    question_description: "Red Hat Customer Portal username"
    required: true
    type: "text"
    variable: "redhat_username"

  - question_name: "Red Hat Password"
    question_description: "Red Hat Customer Portal password"
    required: true
    type: "password"
    variable: "redhat_password"

  - question_name: "Satellite Admin Password"
    question_description: "Password for Satellite admin user"
    required: true
    type: "password"
    variable: "satellite_admin_password"

  # Network Configuration
  - question_name: "DHCP Interface"
    question_description: "Network interface for DHCP service"
    required: true
    type: "text"
    variable: "dhcp_interface"
    default: "eth0"

  - question_name: "DHCP Gateway"
    question_description: "Gateway IP for DHCP configuration"
    required: true
    type: "text"
    variable: "dhcp_gateway"

  - question_name: "DHCP Range"
    question_description: "IP range for DHCP (start_ip end_ip)"
    required: true
    type: "text"
    variable: "dhcp_range"

  - question_name: "DNS Interface"
    question_description: "Network interface for DNS service"
    required: true
    type: "text"
    variable: "dns_interface"
    default: "eth0"

  - question_name: "DNS Reverse Zone"
    question_description: "DNS reverse zone"
    required: true
    type: "text"
    variable: "dns_reverse_zone"

  # Security Options
  - question_name: "Store Credentials in Vault"
    question_description: "Save credentials in encrypted vault"
    required: false
    type: "multiplechoice"
    variable: "store_credentials_in_vault"
    choices: ["true", "false"]
    default: "false"

  # Backup Configuration
  - question_name: "Backup Retention Days"
    question_description: "Days to retain backups"
    required: false
    type: "integer"
    variable: "satellite_backup_retention_days"
    default: 30
    min: 1
    max: 365
```

## Pre-flight Requirements

The playbook automatically validates:
- **RAM**: Minimum 20GB (20480MB)
- **CPU**: Minimum 4 cores
- **Disk**: Minimum 120GB available, recommended 500GB
- **Architecture**: x86_64
- **Network**: Internet connectivity to Red Hat CDN
- **Subscription**: Valid Red Hat subscription
- **Ansible Collections**: ansible.posix, community.general

## Deployment Modes

### 1. Pre-flight Only (`deployment_mode: preflight`)
- Validates system requirements
- Checks network connectivity
- Verifies subscription status
- Does not install Satellite

### 2. Full Deployment (`deployment_mode: full`)
- Runs pre-flight checks
- Installs and configures Satellite 6.17
- Sets up DHCP, DNS, TFTP services
- Configures monitoring and backups
- Deploys management scripts

## Post-Deployment

After successful deployment:

1. **Access Satellite**: https://your-satellite-fqdn
2. **Upload subscription manifest**
3. **Enable repositories**
4. **Sync content**
5. **Configure lifecycle environments**

### Management Commands
- Health Check: `/usr/local/bin/satellite_monitor.sh`
- Backup: `/usr/local/bin/satellite_backup.sh`
- Maintenance Mode: `/usr/local/bin/satellite_maintenance.sh {enable|disable}`

## Security Features

- **Credential Cleanup**: Automatically clears passwords from memory
- **Encrypted Storage**: Optional vault-based credential storage
- **Fail2ban**: SSH protection against brute force attacks
- **SELinux**: Proper security context configuration

## Troubleshooting

### Subscription Manager Timeout Issues
If subscription-manager commands are timing out (common issue), use bypass mode:

```bash
# Run with subscription checks bypassed
ansible-playbook satellite_setup_playbook.yml -e skip_subscription_check=true

# Run preflight only without subscription checks
ansible-playbook satellite_setup_playbook.yml -e deployment_mode=preflight -e skip_subscription_check=true

# Quick deployment bypassing problematic checks
ansible-playbook satellite_setup_playbook.yml -e skip_subscription_check=true -e skip_preflight=true
```

### Common Issues
1. **Insufficient Resources**: Check RAM, CPU, and disk space
2. **Network Connectivity**: Verify internet access and DNS resolution
3. **Subscription Issues**: Ensure valid Red Hat subscription
4. **Missing Collections**: Install required Ansible collections

### Log Locations
- **Deployment**: `/var/log/satellite_deployment_report.log`
- **Health Monitoring**: `/var/log/satellite_monitor.log`
- **Backups**: `/var/satellite-backups/backup.log`
- **Satellite**: `/var/log/foreman/`

## File Structure

```
/home/sgallego/Downloads/GIT/Satellite/
├── satellite_setup_playbook.yml    # Main playbook
├── vars/
│   └── satellite_vars.yml          # Variable definitions
├── templates/
│   └── vault.yml                   # Encrypted credentials
└── README.md                       # This file
```

## Support

For issues or questions:
1. Check `/tmp/satellite_preflight_failure_report.txt` for pre-flight issues
2. Review deployment logs in `/var/log/satellite_deployment_report.log`
3. Monitor health with `/usr/local/bin/satellite_monitor.sh`

## License

This project is distributed under the same terms as Red Hat Satellite 6.17.
    default: 30
    min: 1
    max: 365
```

```
Satellite/
├── satellite_deploy.sh              # 🆕 Unified deployment launcher
├── satellite_setup_playbook.yml     # 🆕 Consolidated playbook
├── inventory.ini                    # 🆕 Simplified inventory
├── vars/satellite_vars.yml          # Configuration variables
├── templates/vault.yml              # Encrypted credentials
└── README.md                        # This file
```

## 🔧 Configuration

### Required Variables (vars/satellite_vars.yml)
```yaml
# Basic configuration
satellite_fqdn: "satellite.example.com"
satellite_organization: "Your Organization"
satellite_location: "Your Location"

# Network settings
dhcp_interface: "enp2s0"
dhcp_range: "192.168.1.150 192.168.1.200"
dns_interface: "enp2s0"
```

### Credentials (templates/vault.yml)
```yaml
# Encrypt with: ansible-vault encrypt templates/vault.yml
vault_satellite_admin_password: "your_admin_password"
vault_redhat_username: "your_redhat_username"
vault_redhat_password: "your_redhat_password"
```

## 📖 Usage Examples

### Interactive Deployment
```bash
# Interactive local deployment with verbose output
./satellite_deploy.sh -i -v

# Interactive remote deployment
./satellite_deploy.sh -r satellite.example.com -u admin -i
```

### Non-Interactive Deployment
```bash
# Full deployment with pre-configured variables
./satellite_deploy.sh

# Force deployment despite warnings
./satellite_deploy.sh -f

# Quick deployment for testing
./satellite_deploy.sh -m quick
```

### Pre-flight Validation Only
```bash
# Run comprehensive pre-flight checks
./satellite_deploy.sh -m preflight

# Pre-flight with verbose output
./satellite_deploy.sh -m preflight -vvv
```

## 🔍 Management Commands

### Post-Deployment Scripts
```bash
# System health monitoring
/usr/local/bin/satellite_monitor.sh

# Manual backup creation
/usr/local/bin/satellite_backup.sh

# Maintenance mode control
/usr/local/bin/satellite_maintenance.sh enable
/usr/local/bin/satellite_maintenance.sh disable

# Performance tuning
/usr/local/bin/satellite_tuning.sh
```

### Service Management
```bash
# Check Satellite services
systemctl status foreman
systemctl status httpd

# View live logs
journalctl -u foreman -f

# Monitor system health
tail -f /var/log/satellite_monitor.log
```

## 📊 System Requirements

### Minimum Requirements
- **OS**: RHEL 9.x
- **RAM**: 20GB
- **CPU**: 4 cores
- **Disk**: 120GB (500GB recommended for production)
- **Architecture**: x86_64

### Network Requirements
- Red Hat CDN connectivity
- Valid Red Hat subscription
- DNS resolution
- NTP synchronization

## 🔒 Security Features

### Hardening Components
- Fail2ban SSH protection
- SELinux policy optimization
- Service-specific firewall rules
- Automated security updates
- Log monitoring and rotation

### Access Control
- Admin user creation with sudo privileges
- SSH key-based authentication
- Maintenance mode capability
- Audit logging

## 📈 Monitoring & Maintenance

### Automated Tasks
- **Daily Backups**: 02:30 UTC to `/var/satellite-backups`
- **Health Checks**: Every 15 minutes
- **Log Rotation**: Daily/Weekly/Monthly schedules
- **Performance Monitoring**: CPU, memory, disk usage

### Manual Monitoring
```bash
# Complete health check
/usr/local/bin/satellite_monitor.sh

# Check backup status
ls -la /var/satellite-backups/

# View deployment report
cat /var/log/satellite_deployment_report.log

# Quick reference guide
cat /root/satellite_quick_reference.txt
```

## 🚨 Troubleshooting

### Common Issues

#### Pre-flight Failures
```bash
# Disk space issues
sudo lvextend -L +50G /dev/mapper/rhel-root
sudo xfs_growfs /

# Missing Ansible collections
ansible-galaxy collection install ansible.posix community.general

# Subscription issues
subscription-manager register --username=YOUR_USER --auto-attach
```

#### Service Issues
```bash
# Restart Satellite services
systemctl restart foreman httpd

# Check service logs
journalctl -u foreman --since "1 hour ago"

# Test API connectivity
curl -k https://satellite.example.com/api/status
```

### Getting Help
1. Check deployment logs: `/var/log/satellite_deployment_report.log`
2. Run health check: `/usr/local/bin/satellite_monitor.sh`
3. Enable verbose mode: `./satellite_deploy.sh -vvv`
4. Review pre-flight output: `./satellite_deploy.sh -m preflight`

## 📚 Documentation

- [Official Red Hat Satellite 6.17 Documentation](https://access.redhat.com/documentation/en-us/red_hat_satellite/6.17)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Red Hat Subscription Management](https://access.redhat.com/documentation/en-us/red_hat_subscription_management/)

## 🆕 Version 2.0 Improvements

### Consolidated Architecture
- ✅ Single unified deployment script replaces 8+ separate scripts
- ✅ All templates embedded as inline content
- ✅ Simplified project structure
- ✅ Enhanced error handling and reporting

### Enhanced Features
- ✅ Interactive credential collection
- ✅ Multiple deployment modes (preflight/full/quick)
- ✅ Simple Content Access support
- ✅ Comprehensive health monitoring
- ✅ Automated performance tuning
- ✅ Enhanced security hardening

### Obsolete Files Removed
- ❌ `preflight_check.sh` (integrated into playbook)
- ❌ `satellite_complete_setup.sh` (replaced by `satellite_deploy.sh`)
- ❌ `run_satellite_remote.sh` (integrated functionality)
- ❌ `satellite_quick_setup.sh` (replaced by quick mode)
- ❌ `skip_disk_check.sh` (integrated as option)
- ❌ Individual template files (embedded inline)

---

**Author**: Shadd Gallegos  
**Version**: 2.0  
**Last Updated**: July 2025

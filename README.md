# Red Hat Satellite 6.17 Role-Based Deployment

## Overview

This repository contains a complete role-based deployment solution for Red Hat Satellite 6.17, converted from standalone projects into reusable Ansible roles with integrated workflow automation.

## Repository Structure

```
Satellite/
├── roles/                              # Ansible roles
│   ├── satellite_build/                # Core Satellite installation
│   ├── satellite_pxe_services/         # PXE, DHCP, TFTP, LibVirt
│   ├── satellite_content/              # Repository & content management
│   └── satellite_provisioning/         # Node provisioning workflows
├── playbooks/                          # Workflow playbooks
│   ├── satellite_complete_deployment.yml  # Full deployment workflow
│   ├── test_individual_roles.yml       # Individual role testing
│   └── node_provisioning_workflow.yml  # Node provisioning
├── group_vars/                         # Shared variables
│   └── all.yml                         # Global configuration
├── tests/                              # Testing framework
├── inventory                           # Inventory file
└── README.md                           # This file
```

## Roles Description

### 1. satellite_build
**Purpose**: Complete Red Hat Satellite 6.17 server installation and configuration

**Features**:
- System preparation and validation
- Network and firewall configuration
- Satellite installer execution
- Post-installation configuration
- Python dependencies and package management
- Red Hat Insights integration

### 2. satellite_pxe_services
**Purpose**: Configure PXE services for automated node provisioning

**Features**:
- TFTP server configuration
- DHCP server setup with LibVirt integration
- Network boot configuration
- Firewall rules for PXE services
- Satellite API integration for host groups

### 3. satellite_content
**Purpose**: Repository and content management configuration

**Features**:
- Red Hat repository enablement (RHEL 8, 9, 10)
- Content view creation and management
- Lifecycle environment setup
- Activation key configuration
- Sync plan automation

### 4. satellite_provisioning
**Purpose**: Automated node provisioning workflows

**Features**:
- VM creation via LibVirt
- Node registration and configuration
- Bulk provisioning capabilities
- Status monitoring and reporting

## Quick Start

### 1. Complete Deployment

Deploy a full Satellite environment:

```bash
ansible-playbook -i inventory playbooks/satellite_complete_deployment.yml
```

### 2. Individual Role Testing

Test specific roles:

```bash
# Test only build role
ansible-playbook -i inventory playbooks/test_individual_roles.yml --tags satellite_build

# Test only PXE services
ansible-playbook -i inventory playbooks/test_individual_roles.yml --tags satellite_pxe_services

# Test only content configuration
ansible-playbook -i inventory playbooks/test_individual_roles.yml --tags satellite_content
```

### 3. Node Provisioning

Provision nodes using the configured Satellite:

```bash
ansible-playbook -i inventory playbooks/node_provisioning_workflow.yml
```

## Configuration

### Global Variables (group_vars/all.yml)

Key configuration variables:

```yaml
# Authentication
satellite_admin_user: "admin"
satellite_admin_password: "{{ vault_satellite_password }}"
satellite_organization: "{{ vault_satellite_organization | default('RedHat') }}"

# Network Configuration
network_range: "10.168.0.0/16"
dhcp_range_start: "10.168.1.100"
dhcp_range_end: "10.168.1.200"

# Role Control
satellite_build_enabled: true
satellite_pxe_enabled: true
satellite_content_enabled: true
```

### Inventory Configuration

Update `inventory` file with your Satellite server details:

```ini
[satellite_servers]
satellite.prod.spg

[satellite_servers:vars]
ansible_host=10.168.151.127
ansible_user=root
```

## Requirements

### System Requirements
- RHEL 9.x
- Minimum 20GB RAM
- 500GB disk space
- Valid Red Hat subscription

### Ansible Requirements
- Ansible 2.15+
- Required collections:
  - community.general
  - ansible.posix
  - redhat.satellite
  - theforeman.foreman

### Install Collections

```bash
ansible-galaxy collection install -r requirements.yml
```

## Integration Points

### Original Projects Converted
1. **Satellite_6.17_Remote_Build** → `satellite_build` role
2. **Satellite_6.17_Remote_PXE_Services** → `satellite_pxe_services` role
3. **Satellite_6.17_Remote_Content_Configure** → `satellite_content` role

### Key Improvements
- ✅ Modular role-based architecture
- ✅ Shared variable management
- ✅ Integrated workflow automation
- ✅ Enhanced error handling
- ✅ Comprehensive testing framework
- ✅ AAP workflow templates ready

## AAP Integration

The roles are designed for Ansible Automation Platform (AAP) with:

- **Job Templates**: Individual role execution
- **Workflow Templates**: Complete deployment chains
- **Credentials**: Vault-based secret management
- **Inventories**: Dynamic inventory support
- **Surveys**: User input for customization

## Testing

Run the comprehensive test suite:

```bash
ansible-playbook -i inventory tests/test_all_roles.yml
```

## Troubleshooting

### Common Issues

1. **Package Lock Issues**: Roles handle foreman-maintain package locks automatically
2. **Python Dependencies**: netaddr and other dependencies are installed automatically
3. **Network Configuration**: Interface detection is automated with manual override options
4. **Firewall Rules**: All required ports are opened automatically

### Debug Mode

Enable verbose output:

```bash
ansible-playbook -i inventory playbooks/satellite_complete_deployment.yml -vvv
```

## Contributing

1. Fork the repository
2. Create feature branches for new roles or improvements
3. Test thoroughly using the provided test framework
4. Submit pull requests with detailed descriptions

## Support

For issues and questions:
- Review the generated deployment summary in `/root/satellite_deployment_summary.md`
- Check test reports in `/tmp/satellite_roles_test_report.md`
- Consult individual role documentation in `roles/*/README.md`

## License

GPL-3.0-or-later

## Author

ShaddGallegos - Red Hat Satellite Automation Specialist

---

**Generated**: September 4, 2025  
**Version**: 1.0.0  
**Satellite Version**: 6.17  
**Tested On**: RHEL 9.6
